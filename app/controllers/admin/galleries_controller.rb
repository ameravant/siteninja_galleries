class Admin::GalleriesController < AdminController
  unloadable # http://dev.rubyonrails.org/ticket/6001
  before_filter :authorization
  before_filter :find_gallery, :only => [ :edit, :update, :destroy ]
  before_filter :get_side_columns
  add_breadcrumb "Galleries", "admin_galleries_path", :only => [:new, :edit, :show]
  
  def index
    if params[:csv]
      redirect_to("/admin/galleries.csv")
    else
      add_breadcrumb "Galleries"
      if params[:q].blank?
        @all_galleries = Gallery.all
      else
        @all_galleries = Gallery.find(:all, :conditions => ["title like ?", "%#{params[:q].strip}%"])
      end
      @galleries = @all_galleries#.paginate(:page => params[:page], :per_page => 30)
    

    # Export CSV
    respond_to do |wants|
      require 'fastercsv'
      @all_galleries = Gallery.all
      wants.html
      wants.csv do
        @outfile = "galleries_" + Time.now.strftime("%Y-%m-%d-%H-%M-%S") + ".csv"
        csv_data = FasterCSV.generate do |csv|
          csv << ["ID", "Title", "Content", "Excerpt", "Date", "Post Type", "Permalink", "Image URL", "Image Title", "Image Caption", "Image Description", "Image Alt Text", "Image Featured", "Attachment URL", "Categories", "Status", "Slug", "Comment Status", "Ping Status", "Post Modified Date"]#, "images_count", "assets_count", "features_count"]
          @all_galleries.each do |gallery|
            #gallery_body = gallery.rendered_body.blank? ? gallery.body : gallery.rendered_body.gsub('data-src', 'src')
            i = Image.first(:conditions => {:viewable_id => gallery.id, :viewable_type => "Gallery", :show_as_cover_image => true})
            i = Image.first(:conditions => {:viewable_id => gallery.id, :viewable_type => "Gallery", :show_in_image_box => true}) if i.blank?
            i = Image.first(:conditions => {:viewable_id => gallery.id, :viewable_type => "Gallery", :show_in_slideshow => true}) if i.blank?
            if !i.blank?
              image_url = i.image(:original)
              image_title = i.title
              image_caption = i.caption
              image_description = i.description
            else
              image_url = ""
              image_title = ""
              image_caption = ""
              image_description = ""
            end
            images = Image.all(:conditions => {:viewable_id => gallery.id, :viewable_type => "Gallery"}, :order => "show_as_cover_image, position asc")
            status = gallery.hidden ? "draft" : "publish"
            
            csv << [gallery.id, gallery.title, gallery.body, gallery.description, gallery.created_at.strftime("%Y-%m-%d %H:%M:%S"), "gallery", gallery_url(gallery), images.collect{|i| i.image(:original)}.join(','), images.collect{|i| i.title}.join(','), images.collect{|i| i.caption}.join(','), images.collect{|i| i.description}.join(','), images.collect{|i| i.title}.join(','), image_url, "", gallery.gallery_categories.collect{|lc| lc.title}.join(','), status, gallery.permalink, "closed", "closed", gallery.updated_at.strftime("%Y-%m-%d %H:%M:%S")]
          end
        end
        send_data csv_data,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=#{@outfile}"
        flash[:notice] = "Export complete!"
      end
    end
end

  end
  
  def new
    @gallery = Gallery.new
  end
  
  def show
    @gallery = Gallery.find params[:id]
    @images = @gallery.images.find :all, :order => "position"
    add_breadcrumb @gallery.title
  end
  
  def edit
    add_breadcrumb "Edit Settings"
  end
  
  def create
    @gallery = current_user.galleries.build params[:gallery]
    @gallery.main_column_id = params[:gallery][:main_column_id]
    @gallery.gallery_category_id = params[:gallery][:gallery_category_id] if params[:gallery][:gallery_category_id]
    @gallery.body = params[:gallery][:body]
    if @gallery.save
      position = 0
      if params[:images]
        params[:images].each do |image|
          position = position + 1
          @image = @gallery.images.build
          @image.image = image
          @image.position = position
          @image.title = "#{@gallery.title}-#{@image.position}"
          @image.save
        end
      end
      flash[:notice] = "#{@gallery.title} gallery created."
      redirect_to [:admin, @gallery, :images]
    else
      render :action => "new"
    end
  end
  
  def update
    position = @gallery.images.size
    if params[:images]
      params[:images].each do |image|
        position = position + 1
        @image = @gallery.images.build
        @image.image = image
        @image.position = position
        @image.title = "#{@gallery.title}-#{@image.position}"
        @image.save
      end
    end
    @gallery.main_column_id = params[:gallery][:main_column_id]
    @gallery.body = params[:gallery][:body]
    @gallery.gallery_category_id = params[:gallery][:gallery_category_id] if params[:gallery][:gallery_category_id]
    @gallery.slideshow = params[:gallery][:slideshow]
    @gallery.hidden = params[:gallery][:hidden]
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = "#{@gallery.title} gallery updated."
      redirect_to admin_galleries_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    menu = @gallery.menus.first
    menu.destroy unless menu.blank?
    @gallery.destroy
    #flash[:notice] = "#{@gallery.title} gallery been deleted."
    respond_to :js
    #redirect_to admin_galleries_path
  end

  def reorder
    params["tree"].each_with_index do |id, position|
      g = Gallery.find_by_id(id)
      g.position = position + 1
      g.save
    end
    render :nothing => true
  end

  private

  def get_side_columns
    @side_columns = Column.all(:conditions => {:column_location => "side_column"})
    @layouts = Column.all(:conditions => {:column_location => "main_column"})
  end
  
  def find_gallery
    begin
      @gallery = Gallery.find params[:id]
    rescue
      flash[:error] = "Gallery not found."
      redirect_to admin_galleries_path
    end
  end

  def authorization
    authorize(@permissions['galleries'], "Galleries")
  end
  
end
