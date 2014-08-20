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

        it{ should_not be_able_to(:index, User) }
        it{ should_not be_able_to(:new, User) }
        it{ should_not be_able_to(:create, User) }
        it{ should_not be_able_to(:edit, User) }
        it{ should_not be_able_to(:update, User) }
        it{ should_not be_able_to(:reset_password, User) } 
      end     
    end
    context "when is an doctor user" do
      context 'on web' do
      	let(:user){create(:doctor_user)}
      	it{ should be_able_to(:index, :agenda) }
      	it{ should be_able_to(:index, :principal) }

        it{ should_not be_able_to(:index, User) }
        it{ should_not be_able_to(:new, User) }
        it{ should_not be_able_to(:create, User) }
        it{ should_not be_able_to(:edit, User) }
        it{ should_not be_able_to(:update, User) }
        it{ should_not be_able_to(:reset_password, User) }     	
      end   
    end
    context "when is an superadmin user" do
      context 'on web' do
        let(:user){create(:superadmin_user)}
        it{ should be_able_to(:index, :agenda) }
        it{ should be_able_to(:index, :principal) }
        it{ should be_able_to(:index, User) }
        it{ should be_able_to(:new, User) }
        it{ should be_able_to(:create, User) }
        it{ should be_able_to(:edit, User) }
        it{ should be_able_to(:update, User) }
        it{ should be_able_to(:reset_password, User) }
      end   
    end
  end
end

