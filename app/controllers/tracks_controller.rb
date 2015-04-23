class TracksController < ApplicationController
	skip_before_action :verify_authenticity_token
  def index
  	@tracks = Track.all
  	binding.pry
  end

  def create
  	@track = Track.new(track_params)
  	if @track.save
      render :nothing => true, :status => :ok
    else
      render :nothing => true, status: :unprocessable_entity
    end
  end

  private
  	def track_params
  		params.require(:track).permit(:status)
  	end
end
