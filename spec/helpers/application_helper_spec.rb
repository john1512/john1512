require 'spec_helper'

describe ApplicationHelper do
  describe "obtaining a sub page" do

    before(:each) do
      Factory(:page)
      Factory(:page, :title=>"Another page")
      Factory(:page, :title=>"Page3")
      @all_pages = Page.all
    end

    it "returns an empty array if curr_page is null" do
      helper.obtain_sub_pages(nil, @all_pages) 
    end
  end
end
