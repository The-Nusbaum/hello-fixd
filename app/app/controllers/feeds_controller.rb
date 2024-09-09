class FeedsController < ApplicationController
  prepend_before_action :authenticate_with_key!, only: %w(index)

  before_action :set_feed_service

  def index
    render json: @feed.events
    # render json: @feed.events
  end

  def set_feed_service
    user_id = current_user.id
    user_id = params[:user_id] unless params[:user_id].blank?
    @feed = FeedService.new(user_id: user_id)
  end
end
