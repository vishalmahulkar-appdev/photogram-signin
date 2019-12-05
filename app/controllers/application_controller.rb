class ApplicationController < ActionController::Base

  before_action(:load_current_user )
  before_action(:force_signin)

  def load_current_user
    @current_user = User.where({:id => session[:user_id]}).at(0)
  end

  def force_signin
    if @current_user == nil 
      redirect_to("/sign_in", {:notice => "Please sign in" })
    end
  end

end
