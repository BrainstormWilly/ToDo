require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do

  let( :user )  { create(:user) }
  let( :admin ) { create(:user, role:"admin") }
  let( :list )  { create(:list, user: user) }
  let( :user_private_list )  { create(:list, user: user, permissions:"to_private") }
  let( :admin_public_list ) { create(:list, user: admin) }
  let( :admin_private_list ) { create(:list, user: admin, permissions:"to_private") }
  let( :item )  { create(:item, list: list) }
  let( :user_private_item ) { create(:item, list: user_private_list) }
  let( :admin_public_item ) { create(:item, list: admin_public_list) }
  let( :admin_private_item ) { create(:item, list: admin_private_list) }

  context "guest" do

    describe "GET #index" do
      it "returns http unauthorized" do
        get :index, list_id: list.id
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, list_id: list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:unauthorized)
      end
      it "does not create new item" do
        expect{post :create, list_id: list.id, item: {title: "Test Item"}}.to change(Item, :count).by(0)
      end
    end

    describe "PUT #update" do
      it "returns http unauthorized" do
        put :update, id: item.id, item: {title:Faker::Lorem.sentence}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE #destroy" do
      it "returns http unauthorized" do
        delete :destroy, id: item.id
        expect(response).to have_http_status(:unauthorized)
      end
      it "does not delete item" do
        delete :destroy, id: item.id
        count = Item.where(id: item.id).count
        expect(count).to eq 1
      end
    end

  end

  context "member" do

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
    end

    describe "GET #index" do
      it "on own list returns http success" do
        get :index, list_id: list.id
        expect(response).to have_http_status(:success)
      end
      it "on public list returns http success" do
        get :index, list_id: admin_public_list.id
        expect(response).to have_http_status(:success)
      end
      it "on unowned private list returns http unauthorized" do
        get :index, list_id: admin_private_list.id
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "POST #create" do
      it "on own list returns http success" do
        post :create, list_id: list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:success)
      end
      it "on own list creates new item" do
        post :create, list_id: list.id, item: {title:"Test Item"}
        expect{post :create, list_id: list.id, item: {title: "Test Item"}}.to change(Item, :count).by(1)
      end
      it "on public list returns http success" do
        post :create, list_id: admin_public_list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:success)
      end
      it "on public list creates new item" do
        post :create, list_id: admin_public_list.id, item: {title:"Test Item"}
        expect{post :create, list_id: admin_public_list.id, item: {title: "Test Item"}}.to change(Item, :count).by(1)
      end
      it "on unowned private list returns http unauthorized" do
        post :create, list_id: admin_private_list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:unauthorized)
      end
      it "on unowned private list does not create new item" do
        post :create, list_id: admin_private_list.id, item: {title:"Test Item"}
        count = Item.where(title:"Test Item").count
        expect(count).to eq 0
      end
    end

    describe "PUT #update" do
      it "on own list returns http success" do
        put :update, id: item.id, item: {completed:true}
        expect(response).to have_http_status(:success)
      end
      it "on own list updates item" do
        put :update, id: item.id, item: {completed:true}
        changed_item = JSON.parse(response.body)
        expect(changed_item["completed"]).to be_truthy
      end
      it "on public list returns http success" do
        put :update, id: admin_public_item.id, item: {completed:true}
        expect(response).to have_http_status(:success)
      end
      it "on public list updates item" do
        put :update, id: admin_public_item.id, item: {completed:true}
        changed_item = JSON.parse(response.body)
        expect(changed_item["completed"]).to be_truthy
      end
      it "on unowned private list returns http unauthorized" do
        put :update, id: admin_private_item.id, item: {completed:true}
        expect(response).to have_http_status(:unauthorized)
      end
      it "on unowned private list does not update item" do
        put :update, id: admin_private_item.id, item: {completed:true}
        changed_item = JSON.parse(response.body)
        expect(changed_item["completed"]).to be_falsey
      end
    end

    describe "DELETE #destroy" do
      it "on own item returns http no content on success" do
        delete :destroy, id: item.id
        expect(response).to have_http_status(:no_content)
      end
      it "on own item returns http not found on unknown item" do
        delete :destroy, id: 0
        expect(response).to have_http_status(:not_found)
      end
      it "on own item deletes item" do
        delete :destroy, id: item.id
        count = Item.where(id: item.id).count
        expect(count).to eq 0
      end
      it "on public item returns http no content on success" do
        delete :destroy, id: admin_public_item.id
        expect(response).to have_http_status(:no_content)
      end
      it "on public item deletes item" do
        delete :destroy, id: admin_public_item.id
        count = Item.where(id: admin_public_item.id).count
        expect(count).to eq 0
      end
      it "on unowned private item returns http unauthorized" do
        delete :destroy, id: admin_private_item.id
        expect(response).to have_http_status(:unauthorized)
      end
      it "on unowned private item does not delete item" do
        delete :destroy, id: admin_private_item.id
        count = Item.where(id: admin_private_item.id).count
        expect(count).to eq 1
      end
    end

  end

  context "admin" do

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(admin.email,admin.password)
    end

    describe "GET #index" do
      it "on own list returns http success" do
        get :index, list_id: admin_public_list.id
        expect(response).to have_http_status(:success)
      end
      it "on private list returns http success" do
        get :index, list_id: user_private_list.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "on own list returns http success" do
        post :create, list_id: admin_public_list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:success)
      end
      it "on own list creates new item" do
        post :create, list_id: admin_public_list.id, item: {title:"Test Item"}
        expect{post :create, list_id: admin_public_list.id, item: {title: "Test Item"}}.to change(Item, :count).by(1)
      end
      it "on unowned private list returns http success" do
        post :create, list_id: user_private_list.id, item: {title:"Test Item"}
        expect(response).to have_http_status(:success)
      end
      it "on unowned private list creates new item" do
        post :create, list_id: user_private_list.id, item: {title:"Test Item"}
        count = Item.where(title:"Test Item").count
        expect(count).to eq 1
      end
    end

    describe "PUT #update" do
      it "on own list returns http success" do
        put :update, id: admin_private_item.id, item: {completed:true}
        expect(response).to have_http_status(:success)
      end
      it "on own list updates item" do
        put :update, id: admin_private_item.id, item: {completed:true}
        changed_item = JSON.parse(response.body)
        expect(changed_item["completed"]).to be_truthy
      end
      it "on unowned private list returns http success" do
        put :update, id: user_private_item.id, item: {completed:true}
        expect(response).to have_http_status(:success)
      end
      it "on unowned private list updates item" do
        put :update, id: user_private_item.id, item: {completed:true}
        changed_item = JSON.parse(response.body)
        expect(changed_item["completed"]).to be_truthy
      end
    end

    describe "DELETE #destroy" do
      it "on own item returns http no content on success" do
        delete :destroy, id: admin_private_item.id
        expect(response).to have_http_status(:no_content)
      end
      it "on unknown item returns http not found" do
        delete :destroy, id: 0
        expect(response).to have_http_status(:not_found)
      end
      it "on own item deletes item" do
        delete :destroy, id: admin_private_item.id
        count = Item.where(id: admin_private_item.id).count
        expect(count).to eq 0
      end
      it "on unowned private item returns http success" do
        delete :destroy, id: user_private_item.id
        expect(response).to have_http_status(:success)
      end
      it "on unowned private item deletes item" do
        delete :destroy, id: user_private_item.id
        count = Item.where(id: user_private_item.id).count
        expect(count).to eq 0
      end
    end

  end


end
