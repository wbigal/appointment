require 'spec_helper'

describe Api::PacientesController, :type => :controller do
  let(:json) { JSON.parse(response.body) }
  render_views
  describe "GET /buscar_pacientes.json" do
  	before(:each) do
      @paciente1 = create(:paciente, apellido_paterno: 'Paez',apellido_materno:'Chavez',
                          nombres:'Wenceslao')
      @paciente2 = create(:paciente, apellido_paterno: 'Raez',apellido_materno:'Juarkez',
                          nombres:'Jose')
      @paciente3 = create(:paciente, apellido_paterno: 'Arbul',apellido_materno:'Park',
                          nombres:'Hiai')
      @paciente4 = create(:paciente, apellido_paterno: 'Marcaez',apellido_materno:'Sport',
                          nombres:'Julielsen')
  	end
    context "unprocesable query string" do
    	it 'does not return https succes ' do
        get :buscar_pacientes, format: :json
        expect(response).to_not be_success 
    	end    	
    	it 'returns the correct error response status' do
        get :buscar_pacientes, format: :json, query: 'ed' 
    		expect(response.response_code).to eq(400)
    	end
      it 'returns the correct error response status message' do
        get :buscar_pacientes, format: :json, query: 'a'*255 
        expect(json['status']).to eq('error')
      end
      it 'it shows the correct error message' do 
        get :buscar_pacientes, format: :json, query: 'ed' 
        expect(json['message']).to match('La consulta debe tener 3 caracteres como minimo y maximo 250.')
      end
    end
    context "with a query string" do
      it 'returns the correct response status' do
        get :buscar_pacientes, format: :json, query: 'wen' 
        expect(response.response_code).to eq(200)
      end
      it 'assigns to @pacientes one pacient' do
        get :buscar_pacientes, format: :json, query: 'wen' 
        expect(assigns(:pacientes)).to match_array([@paciente1])
      end
      it 'assigns to @pacientes many pacientes' do
        get :buscar_pacientes, format: :json, query: 'Aez' 
        expect(assigns(:pacientes)).to match_array([@paciente1,@paciente2,@paciente4])
      end
      it 'returns all matched pacients on json format' do
        get :buscar_pacientes, format: :json, query: 'ark'
        expect(json.collect{|paciente| paciente["full_name"]}).to eq([@paciente2.full_name,
                                                                @paciente3.full_name]) 
      end
    end  
  end
end
