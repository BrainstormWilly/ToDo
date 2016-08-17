require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do

  let( :user )        { create(:user) }
  let( :other_user )  { create(:user) }
  let( :admin )       { create(:user, role:"admin") }
  let( :list )        { create(:list, user: user) }
  let( :other_list )  { create(:list, user: other_user) }
  let( :admin_list )  { create(:list, user: admin) }

  context "guest" do

    describe "GET #index" do
      it "returns http unauthorized" do
        get :index, user_id: 1
        expect(response).to have_http_status(401)
      end
    end

    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, list: {title:"Test List"}
        expect(response).to have_http_status(401)
      end
      it "does not create new list" do
        expect{post :create, list: {title: "Test List"}}.to change(List, :count).by(0)
      end
    end

    describe "DELETE #destroy" do
      it "returns http unauthorized" do
        delete :destroy, id: list.id
        expect(response).to have_http_status(401)
      end
      it "does not delete user" do
        delete :destroy, id: list.id
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
        get :index, user_id: user.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "returns http success" do
        post :create, list: {title:"Test List"}
        expect(response).to have_http_status(:success)
      end
      it "creates new list" do
        expect{post :create, list: {title: "Test List"}}.to change(List, :count).by(1)
      end
    end

    describe "DELETE #destroy" do
      it "returns http no content on success" do
        delete :destroy, id: list.id
        expect(response).to have_http_status(:no_content)
      end
      it "returns http not found on unknown list" do
        delete :destroy, id: 0
        expect(response).to have_http_status(:not_found)
      end
      it "deletes list" do
        delete :destroy, id: list.id
        count = List.where(id: list.id).count
        expect(count).to eq 0
      end
    end

  end

  context "admin" do

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(admin.email,admin.password)
    end

    describe "GET #index" do
      it "returns http success" do
        get :index, user_id: admin.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "with own list returns http success" do
        post :create, list: {title:"Test List"}
        expect(response).to have_http_status(:success)
      end
      it "with own list creates new list" do
        expect{post :create, list: {title: "Test List"}}.to change(List, :count).by(1)
      end
    end

    describe "DELETE #destroy" do
      it "with own list returns http no content on success" do
        delete :destroy, id: admin_list.id
        expect(response).to have_http_status(:no_content)
      end
      it "returns http not found on unknown list" do
        delete :destroy, id: 0
        expect(response).to have_http_status(:not_found)
      end
      it "with own list deletes list" do
        delete :destroy, id: admin_list.id
        count = List.where(id: admin_list.id).count
        expect(count).to eq 0
      end
    end

  end


end
