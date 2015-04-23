class TracksController < ApplicationController
  def index
  	@tracks = Track.all
  end

  def create
  	@track = Track.new(track_params)
  	@track.save
  end

  private
  	def track_params
  		params.require(:track).permit(:status)
  	end
end
