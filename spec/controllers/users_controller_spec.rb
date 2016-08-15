require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do

  let( :user ) { create(:user) }
  let(:new_user_attributes) do
    {
      name: "ToDoer",
      email: "me@todo.com",
      password: "123456",
      password_confirmation: "123456"
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
      it "returns http success" do
        post :create, user: new_user_attributes
        expect(response).to have_http_status(:success)
      end
      it "creates new user" do
        expect{post :create, user: new_user_attributes}.to change(User, :count).by(1)
      end
    end

  end



end
