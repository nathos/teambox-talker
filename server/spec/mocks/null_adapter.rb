class NullAdapter
  def authenticate(token)
    yield Talker::Server::User.new("id" => token, "name" => "user#{token}", "email" => "user#{token}@example.com")
  end
  
  def authorize_room(user, room)
    yield room
  end
  
  def store_connection(type, id, user_id, state)
  end
  
  def update_connection(type, id, user_id, state)
  end

  def delete_connection(type, id, user_id)
  end
  
  def load_connections(&callback)
  end
  
  def insert_paste(room_id, permalink, content, &callback)
  end
  
  def update_paste(permalink, content, attributions, &callback)
  end
  
  def load_paste(permalink)
    yield "test", ""
  end
end

Talker::Server.storage = NullAdapter.new