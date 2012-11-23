class BranchesController < ApplicationController
  respond_to :html
  
  before_filter :check_admin, :except => [ :index, :show ]
  
  def index
    @branches = Branch.all

    respond_with(@branches)
  end

  def show
    @branch = Branch.find(params[:id])

    respond_with(@branch)
  end

  def new
    @branch = Branch.new

    respond_with(@branch)
  end

  def edit
    @branch = Branch.find(params[:id])
  end

  def create
    @branch = Branch.create(params[:branch])

    respond_with(@branch)
  end

  def update
    @branch = Branch.find(params[:id])
    @branch.update_attributes(params[:branch])
    
    respond_with(@branch)
  end

  def destroy
    @branch = Branch.find(params[:id])
    @branch.destroy

    respond_with(:location => branches_path)
  end
end
