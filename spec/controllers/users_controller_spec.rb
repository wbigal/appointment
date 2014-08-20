require 'spec_helper'

describe UsersController do
  context 'Manage: not authorized user' do
    before(:each) do
      @user = create(:user)
      sign_in @user
    end
    describe 'GETs' do
      it "tries to render the :index view" do
        get :index
        expect(response).to redirect_to root_path   
      end
      it 'tries to render the :new view' do
        get :new
        expect(response).to redirect_to root_path
      end
      it 'tries to render the :edit view' do
        get :edit, id: @user.id
        expect(response).to redirect_to root_path
      end
    end
    describe 'Post methods' do
      it 'tries to make a post on create' do
        post :create, user: {dni: '45454545', cargo: 'Secretario',
                                apellidos_nombres: 'Wenceslao Paez'}
        expect(response).to redirect_to root_path                       
      end
      it 'tries to make a update request' do
        patch :update, id: @user , user: {dni: '21212121', apellidos_nombres: 'hola', cargo: 'Jefe',
                          superadmin: 'false', admin: 'false', organizacional: 'true'}
        expect(response).to redirect_to root_path 
      end
      it 'tries to reset a passwrod' do
        post :reset_password, user_id: @user.id
        expect(response).to redirect_to root_path 
      end       
    end
  end
  
  context 'Manage: authorized user' do
    before(:each) do
      @user = create(:superadmin_user)
      sign_in @user
    end
    describe 'Post #reset_password' do
      context 'the same user' do
        it 'sets error flash message' do
          post :reset_password, user_id: @user.id
          flash[:alert].should =~ /Hubo un problema. No puedes resetear tu propio usuario/i
        end
        it 'not chages the password' do
          password = @user.password
          post :reset_password, user_id: @user.id
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
        it 'sets error flash message' do
          post :reset_password, user_id: @user2.id
          flash[:notice].should =~ /Se ha reseteado correctamente./i
        end       
      end
    end

    describe 'GET #index' do
      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
      it "loads all users into @users" do
        user2 = create(:user, apellido_paterno: 'Abad Abad Juan')
        get :index
        expect(assigns(:users)).to eq([user2, @user])
      end
    end
    describe 'GET #new' do
      it "renders the :new view" do
        get :new
        expect(response).to render_template :new
      end  
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        before do
          post :create, user: {dni: '45454545', apellido_paterno: 'Paez', apellido_materno:'Chavez',
                                nombres: 'Wenceslao', abreviacion:'Ing.', email:'chences2@hotmail.com',
                                sexo: 'MASCULINO', color:'#2a2a2a', superadmin:false, admin:false,
                                doctor:false}
        end
        it "saves the new user in the database" do
          expect(User.last.dni).to eq('45454545')
        end

        it "redirects to users#index" do
          expect(response).to redirect_to users_path
        end

        it "show the creation flash message" do
          flash[:notice].should =~ /Se registró correctamente el usuario/i
        end
      end
      context 'with invalid attributes' do
        before do
          post :create, user: {dni: '44444444'}
        end
        it "does not save the new user in the database" do
          expect(User.find_by_dni('44444444')).to eq(nil)
        end
        it "re-renders the :new template" do
          expect(response).to render_template :new
        end
        it "show the fail flash message" do
          flash[:alert].should =~ /Hubo un problema. No se registró el usuario/i
        end
      end
    end
    describe 'GET #edit' do
      it "renders the :edit view" do
        get :edit, id: @user.id
        expect(response).to render_template :edit
      end
      it 'located the request @user' do
        get :edit, id: @user.id
        expect(assigns(:user)).to eq(@user)
      end  
    end
    describe 'PATCH #update' do
      before :each do
        @usuario = create(:user, dni: '21212121', superadmin: false, admin: false,
                          doctor: true)
      end
      context "valid attributes" do
        before do
          unless example.metadata[:skip_before]
            patch :update, user: {dni: '45454545', apellido_paterno: 'Paez', apellido_materno:'Chavez',
                                nombres: 'Wenceslao', abreviacion:'Ing.', email:'chences2@hotmail.com',
                                sexo: 'MASCULINO', color:'#2a2a2a', superadmin:false, admin:true,
                                doctor:false}, id: @usuario.id
          end
        end
        it "located the requested @user" do
          expect(assigns(:user)).to eq(@usuario)
        end

        it "changes @usuario attributes" do
          @usuario.reload
          expect(@usuario.dni).to eq('45454545')
          expect(@usuario.admin).to eq(true)
        end

        it "redirects to the usarios#index" do
          expect(response).to redirect_to users_path
        end
        it "sets the updated message" do
          flash[:notice].should =~ /Se actualizó correctamente el usuario/i
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

        it "re-renders the edit template" do
          expect(response).to render_template :edit
        end

        it "sets the error message" do
          flash[:alert].should =~ /Hubo un problema. No se pudo actualizar los datos./i
        end
      end
    end
  end
end
