class Track
	include Mongoid::Document
	include Mongoid::Timestamps
	field :status, type: Mongoid::Boolean
	
	scope :between, ->(begin_date, end_date){where(:created_at.gte => begin_date.to_datetime, :created_at.lte => end_date.to_datetime.end_of_day)}
	scope :for_this, ->(date){where(:created_at.gte => date.to_datetime, :created_at.lte => date.to_datetime.end_of_day)}
	
	def self.init_days
		days = Hash.new
		start_date = self.first.created_at.to_date
		end_date = DateTime.now
		last = nil
	  (start_date..end_date).each do |date|
		  day = Hash.new
			self.for_this(date).each do |track|
				time_in_seconds = track.created_at.strftime("%M").to_i*60 + track.created_at.strftime("%S").to_i
				if day[track.created_at.strftime("%H").to_i].nil?
					day[track.created_at.strftime("%H").to_i] = {time_in_seconds => track.status}
				else
					day[track.created_at.strftime("%H").to_i].merge!({time_in_seconds => track.status})
				end
			end
			day = day.sort.to_h

		 	24.times do |hour|
	  		if day[hour].nil?
	  			day.merge!({hour => {0 => last}})
	  		else
	  			day[hour][0] = last
	  			day[hour] = day[hour].sort.to_h
		  		last = day[hour].values.last
	  		end
	  	end
	  	if date == Date.today
				24.times do |hour|
					right_now = DateTime.now
					if hour == DateTime.now.strftime('%H').to_i
						time_in_seconds = right_now.strftime("%M").to_i*60 + right_now.strftime("%S").to_i
						day[hour] = {0=>last, time_in_seconds => nil }
					end
					if hour > DateTime.now.strftime('%H').to_i
						day[hour] = {0 => nil}
					end
				end
			end
			days.merge!({date.strftime("%a, %d %b")=>day.sort.to_h}) 
	  end 
	  days
	end

end