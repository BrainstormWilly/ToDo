require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do

  let( :user ) { create(:user) }
  let( :admin ) { create(:user, role: "admin")}
  let(:new_user_attributes) do
    {
      name: "ToDoer",
      email: "me@todo.com",
      password: "123456",
      password_confirmation: "123456",
      role: "member"
    }
  end

  context "guest" do

    describe "GET #index" do
      it "returns http unauthorized" do
        get :index
        expect(response).to have_http_status(401)
      end
    end

    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, user: new_user_attributes
        expect(response).to have_http_status(401)
      end
      it "does not create new user" do
        expect{post :create, user: new_user_attributes}.to change(User, :count).by(0)
      end
    end

    describe "DELETE #destroy" do
      it "returns http unauthorized" do
        delete :destroy, id: user.id
        expect(response).to have_http_status(401)
      end
      it "does not delete user" do
        delete :destroy, id: user.id
        count = User.where(id: user.id).count
        expect(count).to eq 1
      end
    end

  end

  context "member" do

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, user: new_user_attributes
        expect(response).to have_http_status(:unauthorized)
      end
      it "does not create new user" do
        expect{post :create, user: new_user_attributes}.to change(User, :count).by(0)
      end
    end

    describe "DELETE #destroy self" do
      it "returns http no content" do
        delete :destroy, id: user.id
        expect(response).to have_http_status(:no_content)
      end
      it "deletes user" do
        delete :destroy, id: user.id
        count = User.where(id: user.id).count
        expect(count).to eq 0
      end
    end

    describe "DELETE #destroy other" do
      it "returns http unauthorized" do
        delete :destroy, id: admin.id
        expect(response).to have_http_status(:unauthorized)
      end
      it "does not delete user" do
        delete :destroy, id: admin.id
        count = User.where(id: admin.id).count
        expect(count).to eq 1
      end
    end

  end

  context "admin" do

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(admin.email,admin.password)
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create good user" do
      it "returns http no content" do
        post :create, user: new_user_attributes
        expect(response).to have_http_status(:success)
      end
      it "creates new user" do
        expect{post :create, user: new_user_attributes}.to change(User, :count).by(1)
      end
    end

    describe "POST #create bad user" do
      it "returns http unprocessable_entity" do
        post :create, user: {name:"bad_user", password:"123456", password_confirmation:"123456", role: "member"}
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it "does not create new user" do
        expect{post :create, user: {name:"bad_user", password:"123456", password_confirmation:"123456", role: "member"}}.to change(User, :count).by(0)
      end
    end

    describe "DELETE #destroy" do
      it "good user returns http no content" do
        delete :destroy, id: user.id
        expect(response).to have_http_status(:no_content)
      end
      it "bad user returns http not found" do
        delete :destroy, id: 0
        expect(response).to have_http_status(:not_found)
      end
      it "good user deletes user" do
        delete :destroy, id: user.id
        count = User.where(id: user.id).count
        expect(count).to eq 0
      end
    end

  end



end
