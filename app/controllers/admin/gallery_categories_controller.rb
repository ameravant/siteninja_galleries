class Admin::GalleryCategoriesController < AdminController
  unloadable # http://dev.rubyonrails.org/ticket/6001
  before_filter :authorization
  before_filter :find_gallery_category, :only => [ :edit, :update, :destroy ]
  before_filter :add_crumbs
  before_filter :get_layouts
  add_breadcrumb "Categories", "admin_gallery_categories_path", :except => [ :index, :destroy ]
  add_breadcrumb "New Category", nil, :only => [ :new, :create ]
  
  def index
    @gallery_categories = GalleryCategory.active
    add_breadcrumb "Categories", nil
  end

  def new
    @gallery_category = GalleryCategory.new
  end

  def create
    @gallery_category = GalleryCategory.new(params[:gallery_category])
    if @gallery_category.save
      flash[:notice] = "Category \"#{@gallery_category.title}\" created."
      redirect_to admin_gallery_categories_path
    else
      render :action => "new"
    end
  end

  def edit
    add_breadcrumb @gallery_category.title
  end

  def update
    add_breadcrumb @gallery_category.title
    if @gallery_category.update_attributes(params[:gallery_category])
      flash[:notice] = "Category \"#{@gallery_category.title}\" updated."
      redirect_to admin_gallery_categories_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @gallery_category.update_attribute(:active, false)
    respond_to :js
  end

  private

  def get_layouts
    @side_columns = Column.all(:conditions => {:column_location => "side_column"})
    @layouts = Column.all(:conditions => {:column_location => "main_column"})
  end

  def find_gallery_category
    begin
      @gallery_category = GalleryCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Gallery category was not found. It may have been deleted."
      redirect_to admin_gallery_categories_path
    end
  end

  def authorization
    @templates = Template.all
    if @cms_config['modules']['galleries']
      authorize(@permissions['galleries'], "Galleries")
      if !current_user.has_role(["Admin"])
        flash[:error] = "You do not have permission to access Gallery Categories."
        redirect_to admin_galleries_path 
      end
    else
      flash[:error] = "You do not have permission to access Galleries."
      redirect_to "/"
    end
  end

  def add_crumbs
    add_breadcrumb @cms_config['site_settings']['gallery_title'], "admin_galleries_path"
  end
end

