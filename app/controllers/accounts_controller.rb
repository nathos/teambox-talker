class AccountsController < ApplicationController
  before_filter :top_level_domain_required, :only => [:new, :create]
  
  layout "dialog"
  
  def new
    @account = Account.new
    @user = User.new
  end
  
  def create
    logout_keeping_session!
    @account = Account.new(params[:account])
    @user = @account.users.build(params[:user])
    @user.admin = true
    
    User.transaction do
      @account.save!
      @user.activate!
      self.current_user = @user
      remember_me!

      flash[:notice] = "Thanks for signing up!"
      redirect_to home_url(@account)
    end
    
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
end
