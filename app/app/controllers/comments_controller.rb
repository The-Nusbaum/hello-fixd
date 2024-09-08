class CommentsController < CrudController
  def object_update_params
    params.require(:comment).permit(:message)
  end

  def object_create_params
    params.require(:comment).permit(:post_id, :user_id ,:message)
  end
end
