require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do

  let( :user ) { create(:user) }
  let( :list ) { create(:list, user: user)}

  context "guest" do

    describe "GET #index" do
      it "returns http unauthorized" do
        get :index, user_id: 1
        expect(response).to have_http_status(401)
      end
    end

    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, user_id: 1, list: {title:"Test List", user_id:1}
        expect(response).to have_http_status(401)
      end
      it "does not create new list" do
        expect{post :create, user_id: 1, list: {title: "Test List", user_id:1}}.to change(List, :count).by(0)
      end
    end

    describe "DELETE #destroy" do
      it "returns http unauthorized" do
        delete :destroy, user_id: user.id, id: list.id
        expect(response).to have_http_status(401)
      end
      it "does not delete user" do
        delete :destroy, user_id: user.id, id: list.id
        count = List.where(id: list.id).count
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
        get :index, username: user.email, password: user.password, user_id: user.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "returns http success" do
        post :create, user_id: user.id, list: {title:"Test List", user_id:user.id}
        expect(response).to have_http_status(:success)
      end
      it "creates new list" do
        expect{post :create, user_id: user.id, list: {title: "Test List", user_id:user.id}}.to change(List, :count).by(1)
      end
      it "post with different user returns http unauthorized" do
        post :create, user_id: user.id+1, list: {title:"Test List", user_id:user.id}
        expect(response).to have_http_status(400)
      end
      it "post with different user does not create new list" do
        expect{post :create, user_id: user.id+1, list: {title: "Test List", user_id:user.id}}.to change(List, :count).by(0)
      end
    end

    describe "DELETE #destroy" do
      it "returns http no content on success" do
        delete :destroy, user_id: user.id, id: list.id
        expect(response).to have_http_status(:no_content)
      end
      it "returns http not found on unknown list" do
        delete :destroy, user_id: user.id, id: 0
        expect(response).to have_http_status(:not_found)
      end
      it "does not delete user" do
        delete :destroy, user_id: user.id, id: list.id
        count = List.where(id: list.id).count
        expect(count).to eq 0
      end
    end

  end


end
