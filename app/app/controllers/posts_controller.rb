class PostsController < CrudController
  def object_update_params
    params.require(:post).permit(:body, :title)
  end

  def object_create_params
    params.require(:post).permit(:user_id, :title, :body)
  end
 
end
