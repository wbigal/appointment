require 'spec_helper'

describe PrincipalController do
  describe "GET 'index'" do
  	it "returns http success for admin_user" do
      @user = create(:admin_user)
      sign_in  @user
      get 'index'
      response.should be_success
    end
    it "returns http success for superadmin_user" do
      @user = create(:superadmin_user)
      sign_in  @user
      get 'index'
      response.should be_success
    end
    it "returns http success for doctor_user" do
      @user = create(:doctor_user)
      sign_in  @user
      get 'index'
      response.should be_success
    end
  end
end
