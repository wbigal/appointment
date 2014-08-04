require 'spec_helper'

describe Api::DoctorsController, :type => :controller do
  let(:json) { JSON.parse(response.body) }
  render_views #used for jBuilder
  describe "GET /doctors.json" do
  	before(:each) do
  		@doctor_1 = create(:doctor_user, apellido_paterno: 'Paez',
  												apellido_materno:'Chavez', nombres:'Wenceslao', abreviacion: 'Dr.',
  												color: '#ecr123')
  		@doctor_2 = create(:doctor_user, apellido_paterno: 'Fabian',
  												apellido_materno:'Iparraguire', nombres:'Marlon', abreviacion: 'Dr.',
  												color: '#ecr124')
  		@doctor_3 = create(:doctor_user, apellido_paterno: 'Valero',
  												apellido_materno:'Mallma', nombres:'Rafiqui', abreviacion: 'Dr.',
  												color: '#ecr125')
  		@admin = create(:admin_user)
  		get :index, format: :json 
  	end
  	it 'assings to @doctors only all doctors ordered by full_name' do
  		expect(assigns(:doctors)).to eq([@doctor_2, @doctor_1, @doctor_3])
  	end
  	it 'returns all doctors oj json format' do
  		expect(json.collect{|doctor| doctor["full_name"]}).to eq([@doctor_2.full_name,
  																															@doctor_1.full_name,
  																															@doctor_3.full_name]) 
  	end
  	it 'returns the correct status' do
  		expect(response.response_code).to eq(200)
  	end
  end
end  