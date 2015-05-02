require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TracksHelper. For example:
#
# describe TracksHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TracksHelper, type: :helper do
	describe "calculate proportion" do
		hour = [[0, nil], [1000, true]]
		it "should calculate proportion when not last" do
			expect(helper.proportion_for_these(hour, 0, 0)).to eq(1000/60.0)
		end
		it "should calculate proportion when last" do
			expect(helper.proportion_for_these(hour, 1, 1000)).to eq(2600/60.0)
		end
	end
end
