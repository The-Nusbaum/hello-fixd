class PostsController < CrudController
  def object_update_params
    params.require(:post).permit(:body, :title)
  end

  def object_create_params
    params.require(:post).permit(:user_id, :title, :body)
  end

  def set_object_user
    @object.user = current_user
  end

  def forbid_third_party
    head :forbidden unless @object.user == current_user
  end
 
end
