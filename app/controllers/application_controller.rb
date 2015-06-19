class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logined
    if Media.authentication?
      redirect_to search_path
    end
  end

  def authentication
    unless Media.authentication?
      redirect_to root_path
    end
  end

end
