require 'mixpanel-ruby'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :init_action
  
  layout :layout_by_resource
  skip_before_action :authenticate_user!, only: [:set_currency]
  before_filter :add_www_subdomain
  before_filter :set_current_user
  before_action :redirect_to_checkout

  def set_currency
    session[:currency] = params["footer-currency"]
    redirect_to params["current-url"]
    # render json: true.to_json
  end

  protected

  def layout_by_resource
    if devise_controller?
      "users"
    else
      "application"
    end
  end

  def init_action

    # setting current currency
    CUSTOM_CONFIG[:root_url] = root_url
    session[:currency] = 'MYR' if session[:currency].blank?
    gon.current_currency = session[:currency]
    gon.currency_symbols = get_all_currency_symbols

    # setting currency rates
    rates = {}
    bank = Money::Bank::GoogleCurrency.new
    default_currency = 'USD'
    get_all_currencies.each do |currency|
      if default_currency == currency
        rate = 1.0
        session["currency-convert-USD"] = "1.0"
      else
        if session["currency-convert-#{currency}"].blank?
          rate = bank.get_rate(default_currency, currency)
          # rate = 1.0
          session["currency-convert-#{currency}"] = rate.to_s
        else
          rate = session["currency-convert-#{currency}"].to_f
        end
      end
      rates[currency] = rate
    end

    if !devise_controller? && params[:action] != "merchant_landing"
      session["is_become_merchant"] = false
    end


    gon.currency_rates = rates
    gon.is_display_currency_exchange = true
  end

  private

    def mixpanel
      @mixpanel ||= Mixpanel::Tracker.new '6a074aecbabf21341e32c9631632712e', { :env => request.env }
    end

    def add_www_subdomain
      if Rails.env.production?
        unless /^www/.match(request.host)
          redirect_to("#{request.protocol}www.#{request.host_with_port}",status: 301)
        end
      end
    end

  protected

    def set_current_user
      User.current_user = current_user
    end

    def redirect_to_checkout

      if user_signed_in? && session[:pending_invoice].present? && session[:is_require_load_pending_invoice] 
        if params["controller"] == "invoices" && params["action"] == "new"
          
        else
          session[:pending_invoice] = nil
          session[:is_require_load_pending_invoice] = false
        end
        return
      end

      # redirect to payment page again if signin after fill out the fields on payment page
      if user_signed_in? && session[:pending_invoice].present?
        redirect_to new_invoice_path
      end
    end

    def set_product_currency_attributes(products)
      products.each do |product|
        if product.currency != session[:currency]
          rate = session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{product.currency}"].to_f
        else
          rate = 1.0
        end
        product.price_with_currency = (product.price_cents.to_f * rate / 100).round(2)
        product.current_currency = session[:currency]
      end
    end

end
