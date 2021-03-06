class MessagesController < ApplicationController
  before_filter :registered_user_required
  before_filter :find_room
  
  def create
    render :json => "Missing message", :status => 400 and return unless params[:message]
    
    @message = @room.send_message(params[:message], :user => current_user)
    
    render :json => @message, :status => :created
  end
  
  private
    def find_room
      @room = current_account.rooms.find(params[:room_id])
    end
end
