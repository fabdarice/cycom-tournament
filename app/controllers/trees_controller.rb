class TreesController < ApplicationController
  respond_to :html
  
  def index
    @trees = Tree.find(:all)

    respond_with(@trees)
  end

  def show
    @tree = Tree.find(params[:id])
    if @tree.tree_type == Tree::DOUBLE
      @final = @tree.tree_positions.where(:position => 1).first
    end

    respond_with(@tree)
  end

  def new
    @tree = Tree.new
    @tree.tournament_id = params[:tournament_id]

    respond_with(@tree)
  end

  def edit
    @tree = Tree.find(params[:id])
  end

  def create
    @tree = Tree.create(params[:tree])

    respond_with(@tree)
  end
  
  def update
    @tree = Tree.find(params[:id])
    @tree.update_attributes(params[:tree])
    
    respond_with(@tree)
  end

  def destroy
    @tree = Tree.find(params[:id])
    @tree.destroy

    respond_with(:location => trees_path)
  end

  def generate
    @tree = Tree.find(params[:id])
    @tree.tournament.fill_tree
    
    redirect_to :back
  end
end
