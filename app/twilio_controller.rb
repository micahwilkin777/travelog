def status
	skip_before_action :authenticate_user!
 # the status can be found in params['MessageStatus']
 
 # send back an empty response
 
 render_twiml Twilio::TwiML::Response.new
 
end