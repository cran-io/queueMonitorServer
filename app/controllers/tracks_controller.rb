class TracksController < ApplicationController
	skip_before_action :verify_authenticity_token
  before_action :set_chart, :only => [:index, :refresh, :refresh_head]
  
  def index	
		@tracks = Track.between Date.today-10, Date.today
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
  private
    def track_params
      params.require(:track).permit(:status)
    end

    def set_chart  
      @begin_date = params[:begin_date] || Date.today-10
      @end_date = params[:end_date] || Date.today
      @days = Track.init_days @begin_date.to_date, @end_date.to_date
  	end
end
