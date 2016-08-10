class Api::ItemsController < ApiController

  before_action :authenticated?
  before_action :authorize_user, only: [:create]

  def create
    item = @current_list.items.create(item_params)
    if item.save
      render json: item
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def item_params
    params.require(:item).permit(:title, :body)
  end

  def authorize_user
    @current_list = List.find(params['list_id'])
    unless @current_user == @current_list.user
      render json: {error: "Authorization Failure", status: 400}, status: 400
    end
  end

end
