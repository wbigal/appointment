require 'spec_helper'

describe AgendaController do
  describe "GET 'index'" do
    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
    it 'assings the name of the angular app' do
    	get :index
    	expect(assigns(:angular_app_name)).to eq('agenda')
  	end
  	it 'assings the server date' do
  		get :index
  		expect(assigns(:server_date)).to eq(Date.today.to_s) 
  	end
  end
end
