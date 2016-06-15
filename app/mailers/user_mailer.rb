class UserMailer < ActionMailer::Base
  default from: "Travelog <support@travelog.com>"
  
  def welcome_message(user)
  	logger.info "{event=registration status=successful user=#{user.email}}"
  	@user = user
  	mail(:to => user.email, :subject => "Welcome to Travelog")
  end

  def welcome_merchant(user,store)
  	logger.info "{event=REGISTRATION_STORE status=successful store=#{user.full_name}}"
    @user = user
    mail(:to => user.email, :subject => "Merchant Signup Confirmed - Travelog")
  end

  def notif_welcome_merchant(user,store)
    logger.info "{event=NOTIF_REGISTRATION_STORE status=successful store=#{user.full_name}}"
    @user = user
    @store = store
    mail(:to => 'mike@travelog.com', :subject => "New Merchant Signup - Travelog")
  end

  def write_review(from_user, product, message)
  	@from_user = from_user
  	@merchant = product.user
  	@message = message
  	@product_name = product.name
  	mail(:to => @merchant.email, :subject => "Review message on Travelog")
  end

  def invite_message(invitee, accept_link)
    @invitee = invitee
    @inviter_name = @invitee.invited_by.full_name
    @accept_link = accept_link
    mail(:to => @invitee.email, :subject => "#{@inviter_name} invited you to Travelog")
  end
end