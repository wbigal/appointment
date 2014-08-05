require 'spec_helper'

describe PrincipalController do
  describe "GET 'index'" do
  	before (:each) do
      @user = create(:admin_user)
      sign_in  @user
    end
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
