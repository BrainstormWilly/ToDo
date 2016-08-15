require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do

  let( :user ) { create(:user) }
  let( :list ) { create(:list, user: user)}
  let( :other_list ) { create(:list, user: user)}

  context "guest" do

    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, list_id: list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(401)
      end
      it "does not create new item" do
        expect{post :create, list_id: list.id, item: {title: "Test Item"}}.to change(Item, :count).by(0)
      end
    end

  end

  context "member" do

    before do

      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
    end

    describe "POST #create" do
      it "returns http success" do
        post :create, list_id: list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:success)
      end
      it "creates new item" do
        expect{post :create, list_id: list.id, item: {title: "Test Item"}}.to change(Item, :count).by(1)
      end
    end

  end


end
