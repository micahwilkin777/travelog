class StoreController < ApplicationController
	before_action :authenticate_user!
	before_action :check_merchant
	def layout_by_resource
    "product"
  end

  def index
  	@store = current_user.store_setting
  end

  def store
    if request.get?
      @store = current_user.profile.store_setting
      @store = StoreSetting.new({:user_id => current_user.id}) if @store_setting.blank?
      logger.info "status=STORE SETTINGS store=#{@store}"
    end
    
  end

  private

  def check_merchant
  	unless current_user.is_merchant?
  		true
  	end
  end

end
