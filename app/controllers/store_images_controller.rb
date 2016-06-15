class StoreImagesController < ApplicationController
	before_action :set_store_image, only: [:show, :edit, :update, :destroy]

	# GET /store_images/new
  def new
    @store_image = StoreImage.new
  end

  # POST /store_images
  # POST /store_images.json
  def create
    @store_image = StoreImage.new(store_image_params)

    respond_to do |format|
      if @store_image.save
        format.html { redirect_to @store_image, notice: 'Store image was successfully created.' }
        # format.json { render :show, status: :created, location: @store_image }
        format.json {render :json => @store_image}
      else
        format.html { render :new }
        format.json { render json: @store_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /store_images/1
  # PATCH/PUT /store_images/1.json
  def update
    respond_to do |format|
      if @store_image.update(store_image_params)
        format.html { redirect_to @store_image.store_setting, notice: 'Store image was successfully updated.' }
        format.json { render :show, status: :ok, location: @store_image }
      else
        format.html { render :edit }
        format.json { render json: @store_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_images/1
  # DELETE /store_images/1.json
  def destroy
    @store_image.destroy
    respond_to do |format|
      format.html { redirect_to store_images_url, notice: 'Store image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_image
      @store_image = StoreImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_image_params
      params.require(:store_image).permit(:store_setting_id, :store_img)
    end

end
