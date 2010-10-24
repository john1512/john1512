# Methods added to this helper will be available to all templates in the application.

# You can extend refinery with your own functions here and they will likely not get overriden in an update.
module ApplicationHelper
  include Refinery::ApplicationHelper # leave this line in to include all of Refinery's core helper methods.
  
	#
	#for shared/_menu.html.erb
	#
	def obtain_sub_pages(curr_page, all_pages)
		return [] if curr_page.blank? or all_pages.blank?
    
		all_pages.reject {|p| p.parent_id != top_level_page_id(curr_page) }
	end
	
	#
	#for _content_page.html.erb
	#
	def flicker_tag_processing( html )
		html.gsub(
			/<p>{{FLICKR:\s*([^}]*)}}<.p>/, 
			"<ul class='jflickrfeed' data-tag='\\1'></ul>"
		)
	end
	
private
  def top_level_page_id(page) 
    page.parent_id.nil? ? page.id : page.parent_id
  end
end
