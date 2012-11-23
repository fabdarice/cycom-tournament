class PostsController < ApplicationController
  respond_to :html
  
  before_filter :check_admin, :except => [ :index, :show ]
  
  def index
    @posts = Post.order("date DESC")

    respond_with(@posts)
  end

  def show
    @post = Post.find(params[:id])

    respond_with(@post)
  end

  def new
    @post = Post.new

    respond_with(@post)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    @post.author_id = session[:user_id]
    @post.save
    
    respond_with(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    
    respond_with(@post)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_with(:location => posts_path)
  end
end
