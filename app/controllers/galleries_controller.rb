class GalleriesController < ApplicationController
  unloadable # http://dev.rubyonrails.org/ticket/6001
  before_filter :find_page
  add_breadcrumb 'Home', "root_path"
  
  def index
    @galleries = Gallery.public
    @page = Page.find_by_permalink!('galleries')
    add_breadcrumb "Galleries"
  end
  
  def show
    begin
      @gallery = Gallery.find(params[:id])
      @owner = @gallery
      @page = Page.find_by_permalink!('galleries')# if @gallery.menus.empty?
      @main_column = ((@page.main_column_id.blank? or Column.find_by_id(@page.main_column_id).blank?) ? Column.first(:conditions => {:title => "Default", :column_location => "main_column"}) : Column.find(@page.main_column_id))
      @main_column_sections = ColumnSection.all(:conditions => {:column_id => @main_column.id, :visible => true, :column_section_id => nil})
      @gallery.menus.empty? ? @menu = @page.menus.first : @menu = @gallery.menus.first
      @smoothgallery = true if @gallery.slideshow?
      if !@gallery.column.blank? or !@page.column.blank?
        if @gallery.column.blank?
          @side_column_sections = @page.column.column_sections
        else
          @side_column_sections = @gallery.column.column_sections
        end
      end
      @gallery_category = @gallery.gallery_category unless @gallery.gallery_category.blank?
      add_breadcrumb "Galleries", galleries_path
      add_breadcrumb @gallery.title 
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "That gallery could not be found. It may have been deleted."
      redirect_to galleries_path
    end
  end
  
  
  private
  
    def find_page
      @tags = Image.tag_counts
      @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    end
  
end
