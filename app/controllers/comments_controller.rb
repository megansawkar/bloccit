class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    id = params[:post_id] || params[:topic_id]
    if params[:post_id]
      @parent = Post.find id
    elsif params[:topic_id]
      @parent = Topic.find id
    end

    @comment = @parent.comments.find params[:id]
    @comment.save
  end
#    @post = Post.find(params[:post_id])
#    comment = @post.comments.new(comment_params)
#    comment.user = current_user

#    if comment.save
#      flash[:notice] = "Comment saved successfully."
#      redirect_to [@post.topic, @post]
#    else
#      flash[:alert] = "Comment failed to save."
#      redirect_to [@post.topic, @post]
#    end
#  end

  def destroy
    @parent = params[:post_id] || params[:topic_id]
    @comment = @parent.comments.new comment_params
    @comment.destroy
  end
#     @post = Post.find(params[:post_id])
#     comment = @post.comments.find(params[:id])

#     if comment.destroy
#       flash[:notice] = "Comment was deleted successfully."
#       redirect_to [@post.topic, @post]
#     else
#       flash[:alert] = "Comment couldn't be deleted. Try again."
#       redirect_to [@post.topic, @post]
#     end




  private

  def comment_params
    params.require(:comment).permit(:x, :y)
  end

  def authorize_user
     comment = Comment.find(params[:id])
     unless current_user == comment.user || current_user.admin?
       flash[:alert] = "You do not have permission to delete a comment."
       redirect_to [comment.post.topic, comment.post]
     end
   end
end
