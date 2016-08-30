class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    id = params[:post_id] || params[:topic_id]
    if params[:post_id]
      @parent = Post.find id
      redirect = [@parent.topic, @parent]
    elsif params[:topic_id]
      @parent = Topic.find id
      redirect = @parent
    end
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.commentable = @parent

    if @comment.save
      flash[:notice] = "Comment saved successfully."
      redirect_to redirect
    else
      flash[:alert] = "Comment failed to save."
      redirect_to redirect
    end
  end

  def destroy
    id = params[:post_id] || params[:topic_id]
    if params[:post_id]
      @parent = Post.find id
      redirect = [@parent.topic, @parent]
    elsif params[:topic_id]
      @parent = Topic.find id
      redirect = @parent
    end
    comment = Comment.find params[:id]

     if comment.destroy
       flash[:notice] = "Comment was deleted successfully."
       redirect_to redirect
     else
       flash[:alert] = "Comment couldn't be deleted. Try again."
       redirect_to redirect
     end
   end 




  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
     comment = Comment.find(params[:id])
     unless current_user == comment.user || current_user.admin?
       flash[:alert] = "You do not have permission to delete a comment."
       redirect_to [comment.post.topic, comment.post]
     end
   end
end
