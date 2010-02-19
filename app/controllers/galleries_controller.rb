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
      @page = Page.find_by_permalink!('galleries') if @gallery.menus.empty?
      @gallery.menus.empty? ? @menu = @page.menus.first : @menu = @gallery.menus.first
      @smoothgallery = true if @gallery.slideshow?
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
