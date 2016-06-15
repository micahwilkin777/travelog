class Comment < ActiveRecord::Base
	belongs_to :invoice

	validates :content, :presence => true

	scope :order_by_updated, -> {order('updated_at desc')}
	scope :default, -> {order('created_at desc')}

	def format_date
    end_time = Time.now
    start_time = self.created_at
    time_difference = TimeDifference.between(start_time, end_time).in_each_component
    
    if time_difference[:seconds].to_i < 5
      date_str = " Just now"
    elsif time_difference[:seconds].to_i < 60
      date_str = time_difference[:seconds].to_i.to_s
      date_str += " seconds ago"
    elsif time_difference[:minutes].to_i < 60 
      date_str = time_difference[:minutes].to_i.to_s
      date_str += " minute(s) ago"
    elsif time_difference[:hours].to_i < 24
      date_str = time_difference[:hours].to_i.to_s
      date_str += " hour(s) ago"
    elsif time_difference[:days].to_i < 2
      date_str = time_difference[:days].to_i.to_s
      date_str += " day ago"
    else
      date          = start_time.in_time_zone("America/Los_Angeles")
      month         = date.strftime "%B"
      day           = date.strftime "%d"
      suffixes      = ['th', 'st', 'nd', 'rd', 'th',
                       'th', 'th', 'th', 'th', 'th'];
      suffix        = suffixes[day.last.to_i]
      if (day.to_i > 10 && day.to_i < 20)
        suffix = 'th'
      end

      date_str      = month + " " + day + suffix + ", "
      date_str     += date.strftime "%Y %l:%M%P %Z"
    end
    date_str
  end

end
