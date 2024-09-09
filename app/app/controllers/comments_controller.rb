class CommentsController < CrudController
  def object_update_params
    params.require(:comment).permit(:message)
  end

  def object_create_params
    params.require(:comment).permit(:post_id, :message)
  end

  def set_object_user
    @object.user = current_user
  end

  def forbid_third_party
    head :forbidden unless @object.user == current_user
  end
end
