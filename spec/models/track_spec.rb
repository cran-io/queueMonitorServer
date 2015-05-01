require 'rails_helper'

RSpec.describe Track, type: :model do
 	describe "validations" do
		it {should validate_inclusion_of(:status).in_array([true,false])}
		it {should validate_presence_of(:sent_at)}
	end

	describe "methods" do
		describe "init days" do
			context "with or without tracks" do
				it "should not be empty" do
					expect(Track.init_days(Date.today-10, Date.today)).to_not be_empty
				end
			end
		end
	end
end
