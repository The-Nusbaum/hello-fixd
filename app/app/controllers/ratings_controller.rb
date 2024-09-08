class RatingsController < CrudController
  def object_update_params
    params.require(:rating).permit(:rating)
  end

  def object_create_params
    params.require(:rating).permit(:user_id, :rater_id, :rating)
  end
end
