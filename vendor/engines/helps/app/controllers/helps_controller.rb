class HelpsController < ApplicationController

  before_filter :find_all_helps
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @help in the line below:
    present(@page)
  end

  def show
    @help = Help.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @help in the line below:
    present(@page)
  end

protected

  def find_all_helps
    @helps = Help.find(:all, :order => "position ASC")
  end

  def find_page
    @page = Page.find_by_link_url("/helps")
  end

end
