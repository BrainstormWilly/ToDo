class Api::UsersController < ApiController

  before_action :authenticated?
  # before_action :authorize_admin, only: [:create]
  # before_action :authorize_user, only: [:destroy]

  def index
    users = policy_scope(User)
    render json: users, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    authorize user
    if user.save
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
     begin
       user = User.find(params[:id])
       authorize user
       user.destroy
       render json: {}, status: :no_content
     rescue ActiveRecord::RecordNotFound
       render :json => {}, :status => :not_found
     end
   end


  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation)
  end

  # def authorize_admin
  #   unless @current_user.admin?
  #     render json: {error: "Authorization Failure", status: 400}, status: 400
  #   end
  # end
  #
  # def authorize_user
  #   unless @current_user.admin? || @current_user.id.to_s==params["id"]
  #     render json: {error: "Authorization Failure", status: 400}, status: 400
  #   end
  # end


end
