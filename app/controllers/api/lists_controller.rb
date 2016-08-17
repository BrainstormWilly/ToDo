class Api::ListsController < ApiController

  before_action :authenticated?

  def index
    if @current_user.admin?
      lists = List.all
    else
      lists = List.where(user:@current_user)
    end
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

  def destroy
     begin
       list = List.find(params[:id])
       if list.user==@current_user || @current_user.admin?
         list.destroy
         render json: {}, status: :no_content
       else
         render json: {error: "Authorization Failure", status: 400}, status: 400
       end
     rescue ActiveRecord::RecordNotFound
       render :json => {}, :status => :not_found
     end
   end

  private

  def list_params
    params.require(:list).permit(:title, :description)
  end

end
