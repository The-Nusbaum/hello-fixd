class CrudController < ApplicationController
  before_action :set_object, only: %w[update show destroy]
  
  def create
    @object = klass.new(object_create_params)
    @object.save

    render json: @object, status: :created and return if @object.valid?
      
    head :bad_request
  end

  def show
    render json: @object
  end

  def update
    render json: @object, status: :ok and return if @object.update(object_update_params)

    head :bad_request
  end

  def destroy
    head :no_content and return unless @object.destroy.nil?
    head :bad_request
  end

  def klass
    self.class
      .name.sub('Controller','')
      .singularize
      .constantize
  end

  def set_object
    @object = klass.find params[:id]
    head :not_found if @object.nil?
  end

  def object_update_params
    #implement in individual controllers
  end

  def object_create_params
    #implement in individual controllers
  end
end