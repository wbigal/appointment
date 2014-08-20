require 'spec_helper'

describe AgendaController do
  describe "GET 'index'" do
    context 'admin user' do
      before (:each) do
        @user = create(:admin_user)
        sign_in  @user
      end
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
    context 'superadmin user' do
      before (:each) do
        @user = create(:superadmin_user)
        sign_in  @user
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end
    context 'superadmin user' do
      before (:each) do
        @user = create(:doctor_user)
        sign_in  @user
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end
