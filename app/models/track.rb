class Track
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: Mongoid::Boolean
  field :sent_at, type: DateTime
  
  validates :status, :inclusion => {:message =>"not boolean status", :in => [true, false] }, :on => :create
  validates :sent_at, :presence => true

  scope :between, ->(begin_date, end_date){
    where(:sent_at.gte => begin_date.to_datetime, :sent_at.lte => end_date.to_datetime.end_of_day)
  }

  scope :before, ->(date){
    where(:sent_at.lt => date.to_datetime.beginning_of_day)
  }

  scope :for_this, ->(date){
    where(:sent_at.gte => date.to_datetime, :sent_at.lte => date.to_datetime.end_of_day)
  }
  
  def self.init_days begin_date, end_date
    right_now = Time.zone.now
    days = Hash.new
    previous_days = self.before begin_date
    last = previous_days.empty? ? nil : previous_days.last.status
    (begin_date..end_date).each do |date|

      day = Hash.new
      self.for_this(date).each do |track|
        time_in_seconds = track.sent_at.strftime("%M").to_i*60 + track.sent_at.strftime("%S").to_i
        if day[track.sent_at.strftime("%H").to_i].nil?
          day[track.sent_at.strftime("%H").to_i] = {time_in_seconds => track.status}
        else
          day[track.sent_at.strftime("%H").to_i].merge!({time_in_seconds => track.status})
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

      if date == right_now.beginning_of_day.to_date
        24.times do |hour|
          right_now = right_now
          if hour == right_now.strftime('%H').to_i
            time_in_seconds = right_now.strftime("%M").to_i*60 + right_now.strftime("%S").to_i
            day[hour].merge!({ time_in_seconds => nil }) 
          end
          if hour > right_now.strftime('%H').to_i
            day[hour] = {0 => nil}
          end
        end
      end
      
      days.merge!({date.strftime("%a %d %b")=>day.sort.to_h})
    end 
    days
  end

  def self.average day
    day_hash = Hash.new
    percentage_hash = Hash.new
    day_hash = self.init_days day, day
    day_hash = day_hash.values.first
    percentage = 0
    cont = 0
    day_hash.each do |hour, seconds|
      seconds = seconds.to_a
      seconds.each do |key,value|
        if seconds[cont][1] == true
          if seconds[cont+1] != nil
            percentage += seconds[cont+1][0] - seconds[cont][0]
          else
            percentage += 3600 - seconds[cont][0]
          end
        end
        cont += 1
      end
      percentage_hash[hour] = ((percentage/3600.0) * 100).round
      percentage = 0
      cont = 0
    end
    percentage_hash
  end

end