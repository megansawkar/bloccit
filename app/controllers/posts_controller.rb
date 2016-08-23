class PostsController < ApplicationController

  before_action :require_sign_in, except: :show
  before_action :authorize_user, except: [:index, :show]
  before_action :authorize_member, only: [:create, :new, :edit, :update, :destroy]
  before_action :authorize_admin, only: :destroy
#  before_action :authorize_admin, only: [:create, :new, :update, :edit, :destroy]
  before_action :authorize_moderator, only: [:create, :new, :edit, :update]

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = "Post was saved successfully."
      redirect_to [@topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)

    if @post.save
      flash[:notice] = "Post was updated successfully."
      redirect_to [@post.topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:notice] = "\"#{@post.title}\" was deleted successfully."
      redirect_to @post.topic
    else
      flash.now[:alert] = "There was an error deleting the post."
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end


  def authorize_user
#    post = Post.find(params[:id])
    return unless current_user.member?
#    unless current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to new_session_path  #topics_path
  end

  def authorize_admin
#    post = Post.find(params[:id])
    return unless current_user.admin?

    flash[:alert] = "You must be an admin to do that."
    redirect_to new_session_path #topics_path
  end

  def authorize_member
    post = Post.find(params[:id])

    return unless current_user == post.member #|| current_user.admin? || current_user.moderator?
    flash[:alert] = "You must be signed in to do that."
    redirect_to new_session_path
  end

  def authorize_moderator
#    post = Post.find(params[:id])

    return unless current_user.moderator?
      flash[:alert] = "You must be an admin to do that."
      redirect_to new_session_path #[post.topic, post]
  end
end

#    unless current_user == post.user || current_user.admin?
#      flash[:alert] = "You must be an admin to do that."
#      redirect_to [post.topic, post]
#  end
