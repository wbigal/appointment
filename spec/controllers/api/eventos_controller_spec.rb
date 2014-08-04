require 'spec_helper'
describe Api::EventosController, :type => :controller do
  let(:json) { JSON.parse(response.body) }
  render_views

  describe "GET /eventos.json" do
  	before(:each) do
  		@doctor1 = create(:doctor_user)
      @doctor2 = create(:doctor_user)
      @evento1 = create(:evento, doctor_id: @doctor1.id,
                        start_time: '2014-07-10 12:58:01', end_time: '2014-07-10 13:58:01')
      @evento2 = create(:evento, doctor_id: @doctor2.id,
                        start_time: '2014-07-10 12:58:01', end_time: '2014-07-10 13:58:01')
      @evento3 = create(:evento, doctor_id: @doctor2.id,
                        start_time: '2014-06-10 11:58:01', end_time: '2014-06-10 12:58:01')
      @evento4 = create(:evento, doctor_id: @doctor2.id,
                        start_time: '2014-07-11 11:58:01', end_time: '2014-07-11 12:58:01')
  	end
    describe 'provide invalid date params format' do
      it 'returns the correct error response status' do
        get :index, format: :json 
        expect(response.response_code).to eq(400)
      end
      it 'returns the correct error response status message' do
        get :index, format: :json, start: '2014-07-20', end: 'bad'
        expect(json['status']).to eq('error')
      end
      it 'shows the correct error message for not provided date' do 
        get :index, format: :json, start: '', end: '2014-07-20' 
        expect(json['message']).to match('Se requiere la fecha de inicio y fecha final.')
      end
      it 'shows the correct error message for bad date format' do 
        get :index, format: :json, start: '2014-07-20', end: 'bad' 
        expect(json['message']).to match(/no time information in/)
      end
    end
    describe 'provide valid date params format' do
      context 'without doctor_id provided' do
        it 'assings to @eventos all matched events' do
          get :index, format: :json, start: '2014-07-10', end: '2014-07-12'
          expect(assigns(:eventos)).to match_array([@evento1,@evento2,@evento4])
        end
      end
      context 'with doctor_id provided' do
        it 'assings to @eventos all matched events for a finded doctor' do
          get :index, format: :json, start: '2014-07-10', end: '2014-07-12', doctor_id: @doctor2.id
          expect(assigns(:eventos)).to match_array([@evento2,@evento4])
        end
        it 'assings to @eventos all matched events for not finded doctor' do
          get :index, format: :json, start: '2014-07-10', end: '2014-07-12', doctor_id: @doctor2.id+1
          expect(assigns(:eventos)).to match_array([])
        end
      end
      describe 'all matched eventos on json format' do
        before do
          get :index, format: :json, start: '2014-07-10', end: '2014-07-12', doctor_id: @doctor2.id
        end
        it "has assigned evento['start']" do
          expect(json.collect{|evento| DateTime.parse(evento["start"])}).to match_array([@evento4.start_time,
                                                                                @evento2.start_time])
        end
        it 'has the correct keys' do
          expect(json.first.keys).to match_array(["id", "start", "end", "doctor",
                                                  "title", "paciente", "motivo", "color"])          
        end 
      end     
    end
  end
  describe 'POST /eventos.json' do
    context 'bad dates format' do
      before do
        post :create, format: :json, evento:{start: 'wee', end: '2014-07-10 12:58:01'}
      end
      it 'returns the correct error response status' do
        expect(response.response_code).to eq(400)
      end
      it 'returns the correct error response status message' do
        expect(json['status']).to eq('error')
      end
      it 'shows the correct error message for bad date format' do
        expect(json['message']).to match(/no time information in/)
      end
    end
    context 'procesable event' do
      before do
        post :create, format: :json, evento:{start: '2014-07-10 12:58:01',
                                             end: '2014-07-10 13:58:01',
                                             motivo: 'Dolor muela.',
                                             paciente_id: create(:paciente).id,
                                             doctor_id: create(:doctor_user).id}
      end
      it 'returns the correct success response status' do
        expect(response.response_code).to eq(201)
      end
      it 'returns the correct success response status message' do
        expect(json['status']).to eq('success')
      end
      it 'shows the correct success message for bad date format' do
        expect(json['message']).to match(/El evento fue creado correctamente./)
      end
      it 'returns the created event object as json' do
        expect(json['data']['evento']['id']).to eq(Evento.last.id)
      end
      it 'returns the created object with the correct keys' do
        expect(json['data']['evento'].keys).
              to match_array(['id','color','start','end','title','doctor','paciente','motivo'])
      end
    end
    context 'unprocesable event' do
      before do
        post :create, format: :json, evento:{start: '2014-07-10 12:58:01',
                                             end: '2014-07-10 11:58:01',
                                             motivo: 'Dolor muela.',
                                             paciente_id: '',
                                             doctor_id: create(:doctor_user).id + 1}
      end
      it 'returns the correct error response status' do
        expect(response.response_code).to eq(422)
      end
      it 'returns the correct error response status message' do
        expect(json['status']).to eq('error')
      end
      it 'shows the correct error message for bad date format' do
        expect(json['message']).to match(/No procesado./)
      end
      it 'returns the correct error messages' do
        expect(json['data']['errors'].keys).
              to match_array(["base", "doctor", "paciente"])
      end
      it 'returns the correct error messages in base' do
        expect(json['data']['errors']['base']).
              to include("La hora de inicio debe se menor a la hora final.")
      end
    end
  end

  describe 'DELETE /eventos/:id.json' do
    before(:each) do
      @doctor1 = create(:doctor_user)
      @evento1 = create(:evento, doctor_id: @doctor1.id,
                        start_time: '2014-07-10 12:58:01', end_time: '2014-07-10 13:58:01')
    end
    context 'not founded event' do
      before do
        delete :destroy, format: :json, id: @evento1.id+1
      end
      it 'returns the correct error response status' do
        expect(response.response_code).to eq(400)
      end
      it 'returns the correct error response status message' do
        expect(json['status']).to eq('error')
      end
      it 'it shows the correct error message for not provided date' do 
        expect(json['message']).to match(/Couldn't find Evento with/)
      end
    end
    context 'founded event' do
      it 'reduces events by one' do
        expect{
          delete :destroy, format: :json, id: @evento1.id
        }.to change(Evento, :count).by(-1)
      end
      it 'returns the correct success response status' do
        delete :destroy, format: :json, id: @evento1.id
        expect(response.response_code).to eq(200)
      end
      it 'returns the correct success response status message' do
        delete :destroy, format: :json, id: @evento1.id
        expect(json['status']).to eq('success')
      end
      it 'returns the correct success response message' do
        delete :destroy, format: :json, id: @evento1.id
        expect(json['message']).to eq('Evento eliminado.')
      end
    end
  end
end  