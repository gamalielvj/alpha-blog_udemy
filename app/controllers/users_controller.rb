class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy] 
  before_action :requiere_admin, only: [:destroy]
  # GET /users
  def index
    #@users = User.all
     @users = User.paginate(page: params[:page], per_page: 5)
  end

  # GET /users/1
  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 3)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

      if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome to the alpha blog #{@user.username}"
        redirect_to user_path(@user)
      else
        render :new
      end
  end

  # PATCH/PUT /users/1
  def update
      if @user.update(user_params)
        flash[:success] = "Your account was updated successfully"
        redirect_to articles_path
      else
        render :edit
      end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and all articles created by user have been deleted"
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
      if current_user != @user and !current_user.admin?
        flash[:danger] = "You can only edit your own account"
        redirect_to root_path
      end
    end

    def requiere_admin
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
      end
    end

end
  
  
