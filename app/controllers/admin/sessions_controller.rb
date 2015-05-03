class Admin::SessionsController < Comfy::Admin::Cms::BaseController

  before_action :build_session,  :only => [:new, :create]
  before_action :load_session,   :only => [:show, :edit, :update, :destroy]

  def index
    @sessions = Session.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @session.save!
    flash[:success] = 'Session created'
    redirect_to :action => :show, :id => @session
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Session'
    render :action => :new
  end

  def update
    @session.update_attributes!(session_params)
    flash[:success] = 'Session updated'
    redirect_to :action => :show, :id => @session
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Session'
    render :action => :edit
  end

  def destroy
    @session.destroy
    flash[:success] = 'Session deleted'
    redirect_to :action => :index
  end

protected

  def build_session
    @session = Session.new(session_params)
  end

  def load_session
    @session = Session.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Session not found'
    redirect_to :action => :index
  end

  def session_params
    params.fetch(:session, {}).permit(:name)
  end
end