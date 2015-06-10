class TracksController < ApplicationController
	skip_before_action :verify_authenticity_token
  before_action :set_chart, :only => [:index, :refresh, :refresh_head]
  before_action :set_day_track, :only => [:index, :refresh_table]
  def index	
		@tracks = Track.between(Time.zone.now.to_date-10, Time.zone.now.to_date).order('created_at desc').limit 10
  end

  def create
    @track = Track.new track_params
    if @track.save
      render :nothing => true, :status => :ok
    else
      render :nothing => true, status: :unprocessable_entity
    end
  end

  def refresh
    respond_to do |format|
      format.html { render partial: 'days', locals: { days: @days } }
    end
  end

  def refresh_head
    respond_to do |format|
      format.html { render partial: 'days_head', locals: { days: @days } }
    end
  end

  def refresh_table
    respond_to do |format|
      format.html do 
        render partial: 'comparison_table',
          locals: { 
            day_track: @day_track, 
            week_track: @week_track,
            last_5_days: @last_5_days,
            last_10_days: @last_10_days,
            selected_date: @date
          }  
      end
    end
  end

  def show_hour
    hour = parse_an params[:hour] || Hash.new
    respond_to do |format|
      format.html { render partial: 'hour', locals: { hour: hour.to_a, in_chart: false } }
    end
  end

  private
  
    def track_params
      track_params = params.require(:track).permit(:status, :sent_at)
      track_params[:sent_at] = DateTime.strptime(track_params[:sent_at], '%Y-%m-%d-%H-%M-%s').change(:offset => '-0300')
      track_params
    end

    def set_chart  
      @begin_date = params[:begin_date] || Time.zone.now.to_date - 10
      @end_date = params[:end_date] || Time.zone.now.to_date
      @days = Track.init_days @begin_date.to_date, @end_date.to_date
  	end

    def set_day_track
      @date = params[:date].nil? ? Time.zone.now.to_date : params[:date].to_date
      @day_track = Track.per_day_for @date, @date
      @week_track = Track.per_day_for @date - 7.days, @date
      @last_5_days = Track.average_for_last 5, Time.zone.now.to_date
      @last_10_days = Track.average_for_last 10, Time.zone.now.to_date
    end

    def parse_an hour
      hour.each do |seconds,state|
        case state
        when 'true', 'false'
          hour[seconds] = bool_this hour[seconds]
        else
          hour[seconds] = nil
        end
      end
    end

    def bool_this bool_str
      bool_str == 'true'
    end
end
