class UsersController < ApplicationController
  def registrationform
    render({:template => "users/sign_up_form.html.erb"})
  end

  def remove_cookies
    #session[:user_id] = nil

    reset_session
    redirect_to("/", {:notice => "Sign out success"})
  end

  def session_form
    render({:template => "users/sign_in_form.html.erb"})
  end

  def add_cookie
    the_username = params.fetch(:input_username)
    
    the_user = User.where({:username => the_username}).at(0)

    the_password = params.fetch(:input_password)

    if the_user != nil 
      verification_success = the_user.authenticate(the_password)

      if verification_success
        session[:user_id] = the_user.id

        redirect_to("/", {:notice => "Sign in success"})
      else
        reset_session
        redirect_to("/signin", {:alert => "Something went wrong. Try again"})
      end
    else
      redirect_to("/signup", {:alert => "Username does not exist please sign up"})
    end


  end

  def index
    @users = User.all.order({ :username => :asc })

    respond_to do |format|
      format.json do
        render({ :json => @users.as_json })
      end

      format.html do
        render({ :template => "users/index.html" })
      end
    end
  end

  def show
    the_username = params.fetch(:the_username)
    @user = User.where({ :username => the_username }).at(0)

    respond_to do |format|
      format.json do
        render({ :json => @user.as_json })
      end

      format.html do
        render({ :template => "users/show.html.erb" })
      end
    end
  end

  def create
    user = User.new

    user.username = params.fetch(:input_username, nil)
    user.private = params.fetch(:input_private, nil)
    user.likes_count = params.fetch(:input_likes_count, 0)
    user.comments_count = params.fetch(:input_comments_count, 0)

    user.password = params.fetch(:input_password)
    user.password_confirmation = params.fetch(:input_password_confirmation)

    save_status = user.save

    if save_status == true 

      session[:user_id] = user.id
      respond_to do |format|
        format.json do
          render({ :json => @user.as_json })
        end

        format.html do
          redirect_to("/users/#{user.username}")
        end
      end
    else 
      redirect_to("/signup", {:alert => "Something went wrong. Try again."})
    end
  end

  def update
    the_id = params.fetch(:the_user_id)
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch(:input_username, user.username)
    user.private = params.fetch(:input_private, nil)
    user.likes_count = params.fetch(:input_likes_count, user.likes_count)
    user.comments_count = params.fetch(:input_comments_count, user.comments_count)

    user.save

    respond_to do |format|
      format.json do
        render({ :json => user.as_json })
      end

      format.html do
        redirect_to("/users/#{user.username}")
      end
    end
  end

  def destroy
    username = params.fetch(:the_username)
    user = User.where({ :username => username }).at(0)

    user.destroy

    render({ :json => user.as_json })
  end

  def liked_photos
    username = params.fetch(:the_username)
    @user = User.where({ :username => username }).at(0)

    respond_to do |format|
      format.json do
        render({ :json => @user.liked_photos.as_json })
      end

      format.html do
        render({ :template => "users/liked_photos.html.erb" })
      end
    end
  end

  def own_photos
    username = params.fetch(:the_username)
    user = User.where({ :username => username }).at(0)

    render({ :json => user.own_photos.as_json })
  end

  def feed
    username = params.fetch(:the_username)
    @user = User.where({ :username => username }).at(0)

    respond_to do |format|
      format.json do
        render({ :json => @user.feed.as_json })
      end

      format.html do
        render({ :template => "users/feed.html.erb" })
      end
    end
  end

  def discover
    username = params.fetch(:the_username)
    @user = User.where({ :username => username }).at(0)

    respond_to do |format|
      format.json do
        render({ :json => @user.discover.as_json })
      end

      format.html do
        render({ :template => "users/discover.html.erb" })
      end
    end
  end
end
