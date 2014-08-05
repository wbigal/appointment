require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
  	let(:user){nil}
    subject(:ability){ ApiAbility.new(user) }
    context "when is an admin user" do
    	let(:user){create(:admin_user)}
    	it{ should be_able_to(:index, :doctors) }
    	it{ should be_able_to(:index, :eventos) }
      it{ should be_able_to(:create, :eventos) } 
      it{ should be_able_to(:destroy, :eventos) } 
      it{ should be_able_to(:buscar_pacientes, :pacientes) }	     
    end
    context "when is a doctor user" do
      let(:user){create(:doctor_user)}
    	it{ should be_able_to(:index, :doctors) }
      it{ should be_able_to(:index, :eventos) }
      it{ should_not be_able_to(:create, :eventos) } 
      it{ should_not be_able_to(:destroy, :eventos) } 
      it{ should be_able_to(:buscar_pacientes, :pacientes) }
    end
  end
end
