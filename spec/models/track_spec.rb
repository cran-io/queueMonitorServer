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
			
			context "with tracks" do
				sent_at_f1 = Time.zone.now.to_f - 60*60*10
				sent_at_f2 = Time.zone.now.to_f - (60*60*10 + 10)
				sent_at1 = Time.at sent_at_f1
				sent_at2 = Time.at sent_at_f2
				let!(:track_with_true_values){FactoryGirl.create(:track, :status => true, :sent_at => sent_at1)}
				let!(:track_with_false_values){FactoryGirl.create(:track, :status => false, :sent_at => sent_at2)}
				
				it "should contain correct values at specific time" do
					days = Track.init_days(Date.today-2, Date.today)
					expect(days).to_not be_empty
					day = sent_at1.strftime("%a %d %b")
					hour = sent_at1.strftime("%H").to_i
					expect(days[day][hour].values).to match_array [nil, false, true]
				end
				it "should contain nil as last value" do
					days = Track.init_days(Date.today-2, Date.today)
					day = Time.zone.now.strftime("%a %d %b")
					hour = Time.zone.now.strftime("%H").to_i
					expect(days[day][hour].values.last).to be_nil
				end
			end

			context "without tracks" do
			
				it "should have only nil values" do
					days = Track.init_days(Date.today-2, Date.today)
					days.each do |day, hours|
						hours.each do |hour, secs|
								expect(secs.values).to_not include true, false 
								expect(secs.values).to include nil
						end
					end
				end
				
			end
		end
	end
end
