class Admin::GalleriesController < AdminController
  unloadable # http://dev.rubyonrails.org/ticket/6001
  before_filter :authorization
  before_filter :find_gallery, :only => [ :edit, :update, :destroy ]
  before_filter :get_side_columns
  add_breadcrumb "Galleries", "admin_galleries_path", :only => [:new, :edit, :show]
  
  def index
    add_breadcrumb "Galleries"
    if params[:q].blank?
      @all_galleries = Gallery.all
    else
      @all_galleries = Gallery.find(:all, :conditions => ["title like ?", "%#{params[:q].strip}%"])
    end
    @galleries = @all_galleries#.paginate(:page => params[:page], :per_page => 30)
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
    @gallery.main_column_id = params[:gallery][:main_column_id]
    @gallery.body = params[:gallery][:body]
    @gallery.gallery_category_id = params[:gallery][:gallery_category_id] if params[:gallery][:gallery_category_id]
    if @gallery.update_attributes(params[:gallery])
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
      Gallery.update(id, :position => position + 1)
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
