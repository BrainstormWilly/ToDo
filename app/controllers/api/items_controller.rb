class Api::ItemsController < ApiController

  before_action :authenticated?
  # before_action :authorize_user, only: [:create]

  def index
    list = List.find(params['list_id'])
    authorize list, :items?
    items = Item.where(list:list)
    render json: items, each_serializer: ItemSerializer
  end

  def create
    list = List.find(params['list_id'])
    authorize list, :items?
    item = list.items.create(item_params)
    if item.save
      render json: item
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find(params[:id])
    authorize item
    if item.update(item_params)
      render json: item
    else
      render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
     begin
       item = Item.find(params[:id])
       authorize item
       item.destroy
       render json: {}, status: :no_content
     rescue ActiveRecord::RecordNotFound
       render :json => {}, :status => :not_found
     end
   end


  private

  def item_params
    params.require(:item).permit(:title, :body, :completed)
  end

  # def authorize_user
  #   @current_list = List.find(params['list_id'])
  #   unless @current_user == @current_list.user
  #     render json: {error: "Authorization Failure", status: 400}, status: 400
  #   end
  # end

end
