class ProfileDocumentsController < ApplicationController
	before_action :set_profile_document, only: [:show, :edit, :update, :destroy]

	# GET /profile_documents/new
  def new
    @profile_document = ProfileDocument.new
  end

  # POST /profile_documents
  # POST /profile_documents.json
  def create
    @profile_document = ProfileDocument.new(profile_document_params)

    respond_to do |format|
      if @profile_document.save
        format.html { redirect_to @profile_document, notice: 'Profile document was successfully created.' }
        # format.json { render :show, status: :created, location: @profile_document }
        format.json {render :json => @profile_document}
      else
        format.html { render :new }
        format.json { render json: @profile_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_documents/1
  # PATCH/PUT /profile_documents/1.json
  def update
    respond_to do |format|
      if @profile_document.update(profile_document_params)
        format.html { redirect_to @profile_document.store_setting, notice: 'Profile document was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile_document }
      else
        format.html { render :edit }
        format.json { render json: @profile_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_documents/1
  # DELETE /profile_documents/1.json
  def destroy
    @profile_document.destroy
    respond_to do |format|
      format.html { redirect_to profile_documents_url, notice: 'Profile document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_document
      @profile_document = ProfileDocument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_document_params
      params.require(:profile_document).permit(:profile_id, :document, :name)
    end
end
