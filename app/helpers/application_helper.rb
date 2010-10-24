# Methods added to this helper will be available to all templates in the application.

# You can extend refinery with your own functions here and they will likely not get overriden in an update.
module ApplicationHelper
  include Refinery::ApplicationHelper # leave this line in to include all of Refinery's core helper methods.
  
	def obtain_sub_pages(curr_page, all_pages)
		return [] if curr_page.nil? or all_pages.nil?
    
		pid = curr_page.parent_id.nil? ? curr_page.id : curr_page.parent_id
		all_pages.reject {|p| p.parent_id != pid }
	end

end
