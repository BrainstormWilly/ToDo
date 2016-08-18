class Api::ListsController < ApiController

  before_action :authenticated?

  def index
    lists = policy_scope(List)
    render json: lists, each_serializer: ListSerializer
  end

  def create
    list = @current_user.lists.create(list_params)
    authorize list
    if list.save
      render json: list
    else
      render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    list = List.find(params[:id])
    authorize list

    if list.update(list_params)
      render json: list
    else
      render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
     begin
       list = List.find(params[:id])
       authorize list
       list.destroy
       render json: {}, status: :no_content
     rescue ActiveRecord::RecordNotFound
       render :json => {}, :status => :not_found
     end
   end

  private

  def list_params
    params.require(:list).permit(:title, :description, :permissions)
  end

end
