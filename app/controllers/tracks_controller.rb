class TracksController < ApplicationController
  def index
  	@tracks = Track.all
  end

  def create
  end

  private
  	def track_params
  		params.require(:track).permit(:status)
  	end
end
