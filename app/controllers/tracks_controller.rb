class TracksController < ApplicationController
	skip_before_action :verify_authenticity_token
  before_action :set_chart, :only => [:index, :refresh, :refresh_head]
  
  def index	
		@tracks = Track.between(Time.zone.now.to_date-10, Time.zone.now.to_date).order('created_at desc').limit 10
  end

  def create
    @track = Track.new(track_params)
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
      @begin_date = params[:begin_date] || Time.zone.now.to_date-10
      @end_date = params[:end_date] || Time.zone.now.to_date
      @days = Track.init_days @begin_date.to_date, @end_date.to_date
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
