class GalleryCategoriesController < ApplicationController
  unloadable
  add_breadcrumb 'Home', 'root_path'
  before_filter :add_crumbs
  before_filter :find_page
  before_filter :find_galleries_for_sidebar
  
  def show
    begin
      #expires_in 60.minutes, :public => true
      @gallery_category.menus.empty? ? @menu = @page.menus.first : @menu = @gallery_category.menus.first
      @galleries = @gallery_category.galleries
      add_breadcrumb @gallery_category.title
      if !@gallery_category.page_layout.blank?
        @main_column = Column.find_by_id(@gallery_category.main_column_id)
      end
    end
    # respond_to do |wants|
    #   wants.html # index.html.erb
    #   wants.xml { render :xml => @galleries.to_xml }
    #   wants.rss { render :layout => false } # uses index.rss.builder
    # end
  end

  private

  def add_crumbs
    add_breadcrumb 'Galleries', 'gallery_path'
  end

  def find_page
    if @cms_config['modules']['galleries']
      @gallery_category = GalleryCategory.active.find(params[:id])
      if @gallery_category.blank?
        render_404
      else
        @page = Page.find_by_permalink('galleries')# if @gallery_category.menus.empty?
        @main_column = ((@page.main_column_id.blank? or Column.find_by_id(@page.main_column_id).blank?) ? Column.first(:conditions => {:title => "Default", :column_location => "main_column"}) : Column.find(@page.main_column_id))
        @main_column_sections = ColumnSection.all(:conditions => {:column_id => @main_column.id, :visible => true, :column_section_id => nil})
      end
    else
      unless @page = Page.find_by_permalink('galleries')
        render_404
      else
        get_page_defaults(@page)
        render 'pages/show'
      end
    end
  end

  def find_galleries_for_sidebar
    @gallery_categories = GalleryCategory.active
  end
  
end

