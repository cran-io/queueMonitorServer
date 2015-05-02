module TracksHelper
	def proportion_for_these hour, index, key
		if hour[index+1].nil?
 			proportion = 3600 - key.to_i
 		else
 			proportion = hour[index+1].first.to_i - key.to_i
 		end	
		proportion = proportion/60.0
	end
end
