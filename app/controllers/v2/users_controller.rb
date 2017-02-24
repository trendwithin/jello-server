class V2::UsersController < V2::BaseController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /v2/users
  def index
    page = params[:page] || 1
    @users = User.page(page)
    if stale?(@users)
      render json: @users, meta: pagination_meta(@users)
    end
  end

  # GET /v2/users/1
  def show
    if stale?(@user)
      render json: @user
    end
  end

  # POST /v2/users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: v2_user_url(@user)
    else
      respond_with_validation_error @user
    end
  end

  # PATCH/PUT /v2/users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      respond_with_validation_error @user
    end
  end

  # DELETE /v2/users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
