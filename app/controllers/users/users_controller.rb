class Users::UsersController < Users::AdminController

  before_action :build_user, :only => [:new, :create]
  before_action :load_user,  :only => [:edit, :update, :destroy]
  before_action :load_companies, :only => [:edit, :create, :new, :update]
  load_and_authorize_resource :except => [:new, :create]

  def index
    @users = User.accessible_by(current_ability)
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @user.password_confirmation = user_params[:password]
    @user.company = current_company
    @user.save!
    flash[:success] = 'Succesfully created'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:danger] = "Failed to create User: #{e.message}"
    render :action => :new
  end

  def update
    @user.update_without_password(user_params)
    flash[:success] = 'User updated'
    redirect_to :action => :edit, :id => @user
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create User'
    render :action => :edit, :id => @user
  end

  def destroy
    @user.destroy
    flash[:success] = 'User user deleted'
    redirect_to :action => :index
  end

protected

  def build_user
    @user = User.new(user_params)
  end

  def load_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'User not found'
    redirect_to :action => :index
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :role, :company_id, :password,
      :login)
  end

  def load_companies
    @companies = Company.all.select(:id, :title)
  end
end
