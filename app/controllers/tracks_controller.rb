class TracksController < ApplicationController
	skip_before_action :verify_authenticity_token
  before_action :set_chart, :only => [:index, :refresh]
  
  def index	
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
	  	format.html {render partial: 'days', locals: { days: @days } }
  	end
  end

  private
  	def track_params
  		params.require(:track).permit(:status)
  	end

  	def set_chart
  		@tracks = Track.between Date.today-10, Date.today
	  	@days = @tracks.init_days
  	end
end
