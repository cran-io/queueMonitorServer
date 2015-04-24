class Track
	include Mongoid::Document
	include Mongoid::Timestamps
	field :status, type: Mongoid::Boolean
	# scope :between, ->(begin_date, end_date) {where(:created_at.gte => begin_date, :created_at.lte => end_date.to_datetime.end_of_day).group_by {|d| d.created_at.strftime("%d/%m/%Y")}}

	scope :between, ->(begin_date, end_date){where(:created_at.gte => begin_date.to_datetime, :created_at.lte => end_date.to_datetime.end_of_day)}
	scope :for_this, ->(date){where(:created_at.gte => date.to_datetime, :created_at.lte => date.to_datetime.end_of_day)}
	
	def self.init_days
		days = Hash.new
		start_date = self.first.created_at.to_date
		end_date = self.last.created_at.to_date
		last = false
	  (start_date..end_date).each do |date| 
		  day = Hash.new
			self.for_this(date).each do |track|
				if day[track.created_at.strftime("%H").to_i].nil?
					day[track.created_at.strftime("%H").to_i] = [track.status]
				else
					day[track.created_at.strftime("%H").to_i] << track.status
				end
			end
	  	24.times do |hour|
	  		if day[hour].nil?
	  			day.merge!({hour => [last]})
	  		else
	  			last = day[hour].last
	  		end
	  	end
			days.merge!({date.strftime("%d-%m")=>day.sort.to_h}) 
	  end 
	  days		
	end

end
