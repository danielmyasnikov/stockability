class Admin::CompaniesController < Comfy::Admin::Cms::BaseController

  before_action :build_company,  :only => [:new, :create]
  before_action :load_company,   :only => [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:new, :create]

  def index
    @companies = Company.accessible_by(current_ability).page(params[:page])
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
    @company.save!
    flash[:success] = 'Company created'
    redirect_to :action => :show, :id => @company
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Company'
    render :action => :new
  end

  def update
    @company.update_attributes!(company_params)
    flash[:success] = 'Company updated'
    redirect_to :action => :show, :id => @company
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Company'
    render :action => :edit
  end

  def destroy
    @company.destroy
    flash[:success] = 'Company deleted'
    redirect_to :action => :index
  end

protected

  def build_company
    @company = Company.new(company_params)
  end

  def load_company
    @company = Company.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Company not found'
    redirect_to :action => :index
  end

  def company_params
    params.fetch(:company, {}).permit(:title, :description, :address, :suburb, :postcode, :state, :phone, :abn, :acn)
  end
end
