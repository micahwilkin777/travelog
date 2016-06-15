class NotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token, :authenticate_user!

  def notify
  	client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
  	message = client.messages.create from: '+17314187495', to: '+6013540 8888', body: 'You received new Booking from Travelog.com!!!'
  	render nothing: true
  end

end