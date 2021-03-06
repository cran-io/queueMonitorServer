require 'rails_helper'

RSpec.describe TracksController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe "GET #refresh" do
    it "should render days partial" do
      get :refresh
      expect(response).to render_template :partial => '_days'
      expect(response).to have_http_status(:success)
    end
  end
 
  describe "GET #refresh_head" do
    it "should render header partial" do
      get :refresh_head
      expect(response).to render_template :partial => '_days_head'
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "GET #show_hour" do
    context "with hour params" do
      it "should render hour partial" do
        get :show_hour, :hour=>{"900"=>"nil", "1400"=>"false"}
        expect(response).to render_template :partial => '_hour'
        expect(response).to have_http_status(:success)
      end
    end

    context "without hour params" do
      it "should render hour partial" do
        get :show_hour
        expect(response).to render_template :partial => '_hour'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create" do 
  	context "with valid format" do
  		it "should create a track" do
  			expect{
	  			post :create, :track => {:status => false, :sent_at => '2015-05-01-14-21-26-251'}
  			}.to change(Track, :count).by(+1)
  			expect(response).to have_http_status(:success)
  		end

  		it "should not create a track" do
  			expect{
	  			post :create, :track => {:status => nil, :sent_at => '2015-05-01-14-21-26-251'}
  			}.to change(Track, :count).by(0)
  			expect(response).not_to have_http_status(:success)
  		end
  	end
  	context "with invalid format" do
  		it "tries to create a track" do
  			expect{
	  			post :create, :track => {:foobar => false, :sent_at => '2015-05-01-14-21-26-251'}
  			}.to change(Track, :count).by(0)
  			expect(response).not_to have_http_status(:success)
  		end
  	end
  end
end
