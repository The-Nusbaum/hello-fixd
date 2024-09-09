class RatingsController < CrudController
  def object_update_params
    params.require(:rating).permit(:rating)
  end

  def object_create_params
    params.require(:rating).permit(:rater_id, :rating)
  end

  def set_object_user
    @object.rater = current_user
  end

  def forbid_third_party
    head :forbidden unless @object.rater == current_user
  end
end
