class ApiController < ApplicationController

  skip_before_action :verify_authenticity_token

  private

  def authenticated?
    authenticate_or_request_with_http_basic {|username, password|
      @current_user = User.find_by(email: username).try(:authenticate, password);
      @current_user.present?
      # username=="brainstormwilly@gmail.com" && password=="123456"
      # User.where(email: username, password: password).present?
    }
  end

  
end
