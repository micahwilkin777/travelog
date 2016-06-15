module LayoutHelper
	include ApplicationHelper

	def title(page_title, show_title = true)
		content_for(:title) { page_title.to_s }
		@show_title = show_title
	end
	
	def page_title(text=nil)
		return text unless text.blank?
		site_name
	end
end