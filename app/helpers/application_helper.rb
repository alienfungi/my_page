module ApplicationHelper

	def full_title(page_title)
		base_title = "Zane's Site"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	# sets heading to :heading, :title, or "Zane's Site" in that priority
	def heading(page_heading, page_title)
		default_heading = "Zane's Site"
		if page_heading.empty? && page_title.empty?
			default_heading
		elsif page_heading.empty?
			page_title
		else
			page_heading
		end
	end

end
