require 'spec_helper'

describe ApplicationHelper do
  describe "obtaining a sub page" do

    before(:each) do
      Factory(:page, :title => "Gallery")

      ponies = Factory(:page, :title => "Ponies")
        Factory(:page, :title => "Zombie Ponies", :parent_id => ponies.id)
        Factory(:page, :title => "Happy Ponies",  :parent_id => ponies.id)
        Factory(:page, :title => "Crazy Pontes",  :parent_id => ponies.id)
    
      Factory(:page, :title => "Sharks")
      Factory(:page, :title => "About")
      
      @pages = Page.all
    end

    it "has no sub-pages for the gallery" do
      gallery = Page.find_by_title("Gallery")
      helper.obtain_sub_pages(gallery, @pages).size.should == 0
    end

    it "will return 3 subpages for ponies" do
      gallery = Page.find_by_title("Ponies")
      helper.obtain_sub_pages(gallery, @pages).size.should == 3     
    end

    it "returns an empty array if the current page is nil" do
      helper.obtain_sub_pages(nil, @all_pages).should == [] 
    end

    it "returns an empty array if the current page is an empty array" do
      helper.obtain_sub_pages([], @all_pages).should == [] 
    end

    it "returns an empty array if all pages are nil" do
      helper.obtain_sub_pages(@pages.first, nil).should == []
    end

    it "returns an empty array if all pages is an empty array" do
      helper.obtain_sub_pages(@pages.first, []).should == []
    end
  end
end
