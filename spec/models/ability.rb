require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
  	let(:user){nil}
    subject(:ability){ Ability.new(user) }
    context "when is an admin user" do    	
      context 'on web' do
      	let(:user){create(:admin_user)}
      	it{ should be_able_to(:index, :agenda) }
      	it{ should be_able_to(:index, :principal) }
        it{ should be_able_to(:create, :api_eventos) }
        it{ should be_able_to(:destroy, :api_eventos) } 
      end
      context 'on api' do
      end      
    end
    context "when is an doctor user" do
      context 'on web' do
      	let(:user){create(:doctor_user)}
      	it{ should be_able_to(:index, :agenda) }
      	it{ should be_able_to(:index, :principal) }     	
      end
      context 'on api' do
      end      
    end
  end
end

