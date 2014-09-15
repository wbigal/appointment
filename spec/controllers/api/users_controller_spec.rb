require 'spec_helper'
describe Api::UsersController, :type => :controller do
  let(:json) { JSON.parse(response.body) }
  render_views
  context 'not authorized user' do
    before(:each) do
      @user = create(:user)
      sign_in @user
    end
    describe '#index' do
      before do
        get :index, format: :json
      end
      it 'returns the correct status' do  
        expect(response.response_code).to eq(401)
      end
      it 'returns the correct error response status message' do 
        expect(json['status']).to eq('error')
      end
    end    
  end
  context 'authorized user' do
    before(:each) do
      @user = create(:superadmin_user, apellido_paterno:'Paez')
      @user2 = create(:doctor_user, apellido_paterno: 'Abad')
      sign_in @user
    end
    describe '#index' do
      before do        
        get :index, format: :json
      end
      it "loads all users into @users" do
        expect(assigns(:users)).to eq([@user2,@user])
      end
      it 'returns pagination metadata' do
        expect(json.keys).to eq(["current_page", "per_page", "total_pages", "offset", "users"]) 
      end
      it 'returns all users on json format' do
        expect(json['users'].first.keys).to eq(["id", "dni", "full_name", "color", "superadmin",
                                               "admin", "doctor", "deshabilitado"]) 
      end
      it 'returns the correct status' do
        expect(response.response_code).to eq(200)
      end
    end
    describe '#create' do
      context 'with valid attributes' do
        before do
          post :create, format: :json, user: {dni: '45454545', apellido_paterno: 'Paez', apellido_materno:'Chavez',
                                nombres: 'Wenceslao', abreviacion:'Ing.', email:'chences2@hotmail.com',
                                sexo: 'MASCULINO', color:'#2a2a2a', superadmin:false, admin:false,
                                doctor:false}
        end
        it "saves the new user in the database" do
          expect(User.last.dni).to eq('45454545')
        end
        it 'returns the correct success response status' do
          expect(response.response_code).to eq(201)
        end
        it 'returns the correct success response status message' do
          expect(json['status']).to eq('success')
        end
        it 'shows the correct success message for bad date format' do
          expect(json['message']).to match(/El usuario fue creado correctamente./)
        end
        it 'returns the created event object as json' do
          expect(json['data']['user']['id']).to eq(User.last.id)
        end
      end
      context 'with invalid attributes' do
        before do
          post :create, user: {dni: '44444444'}
        end
        it "does not save the new user in the database" do
          expect(User.find_by_dni('44444444')).to eq(nil)
        end
        it 'returns the correct error response status' do
          expect(response.response_code).to eq(422)
        end
        it 'returns the correct error response status message' do
          expect(json['status']).to eq('error')
        end
        it 'shows the correct error message' do
          expect(json['message']).to match(/No procesado./)
        end
      end
    end

    describe '#update' do
      before :each do
        @usuario = create(:user, dni: '21212121', superadmin: false, admin: false,
                          doctor: true)
      end
      context "valid attributes" do
        before do
          unless example.metadata[:skip_before]
            put :update, user: {dni: '45454545', apellido_paterno: 'Paez', apellido_materno:'Chavez',
                                nombres: 'Wenceslao', abreviacion:'Ing.', email:'chences2@hotmail.com',
                                sexo: 'MASCULINO', color:'#2a2a2a', superadmin:false, admin:true,
                                doctor:false}, id: @usuario.id
          end
        end
        it "changes @usuario attributes" do
          @usuario.reload
          expect(@usuario.dni).to eq('45454545')
          expect(@usuario.admin).to eq(true)
        end

        it 'tries to update his own superuser account', skip_before: true do
          patch :update, id: @user, user: {dni: '45454545', apellido_paterno: 'Paez',
                                          apellido_materno:'Chavez',nombres: 'Wenceslao',
                                          abreviacion:'Ing.', email:'chences2@hotmail.com',
                                          sexo: 'MASCULINO', color:'#2a2a2a', superadmin:false,
                                          admin:true,doctor:true}
          @user.reload
          expect(@user.superadmin).to eq(true)
          expect(@user.admin).to eq(true)
          expect(@user.doctor).to eq(true)                
        end

        it 'returns the correct success response status message' do
          expect(json['status']).to eq('success')
        end
        it 'shows the correct success message for bad date format' do
          expect(json['message']).to match(/El usuario fue actualizado correctamente./)
        end
        it 'returns the created event object as json' do
          expect(json['data']['user']['id']).to eq(@usuario.id)
        end
      end
      context "with invalid attributes" do
        before do
          unless example.metadata[:skip_before]
            patch :update, user: {dni: '454545455'}, id: @usuario.id
          end
        end
        it "does not change the enfermeras's attributes" do
          @usuario.reload
          expect(@usuario.dni).to_not eq("454545455")
        end
        it 'returns the correct error response status' do
          expect(response.response_code).to eq(422)
        end
        it 'returns the correct error response status message' do
          expect(json['status']).to eq('error')
        end
        it 'shows the correct error message' do
          expect(json['message']).to match(/No procesado./)
        end
      end
    end
    describe '#reset_password' do
      context 'the same user' do
        before do
          post :reset_password, user_id: @user.id
        end
        it 'returns the correct error response status' do
          expect(response.response_code).to eq(422)
        end
        it 'returns the correct error response status message' do
          expect(json['status']).to eq('error')
        end
        it 'shows the correct error message' do
          expect(json['message']).to match(/No puedes resetear tu propio password./)
        end
        it 'not chages the password' do
          password = @user.password
          @user.reload
          expect(@user.password).to eq(password)
        end 
      end
      context 'other users' do
        before(:each) do
          @user2 = create(:user, dni:'22222222', password: 'holapumba', password_confirmation:'holapumba')
        end
        it 'changes the user password' do
          password = @user.password
          post :reset_password, user_id: @user2.id
          @user2.reload
          expect(@user2.password).to_not eq(password)
        end
        it 'returns the correct error response status message' do
          post :reset_password, user_id: @user2.id
          expect(json['status']).to eq('success')
        end
        it 'shows the correct error message' do
          post :reset_password, user_id: @user2.id
          expect(json['message']).to match(/Se cambio el password del usuario./)
        end       
      end
    end
  end
end
