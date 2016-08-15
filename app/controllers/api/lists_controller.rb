class Api::ListsController < ApiController

  before_action :authenticated?
  before_action :authorize_user, only: [:create]

  def index
    lists = List.all
    render json: lists, each_serializer: ListSerializer
  end

  def create
    list = @current_user.lists.create(list_params)
    if list.save
      render json: list
    else
      render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:title, :description)
  end


  def authorize_user
    unless @current_user.id.to_s == params['user_id']
      render json: {error: "Authorization Failure", status: 400}, status: 400
    end
  end


end
