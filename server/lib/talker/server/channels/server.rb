require "eventmachine"

module Talker::Server
  module Channels
    class Server
      DEFAULT_HOST = "0.0.0.0"
      DEFAULT_TIMEOUT = 30.0 # sec
      DEFAULT_PORT = 8500
      
      attr_reader :host, :port, :channels, :private_key_file, :cert_chain_file
      
      def initialize(options={})
        @host = options[:host] || DEFAULT_HOST
        @port = options[:port] || DEFAULT_PORT
        @timeout = options[:timeout] || DEFAULT_TIMEOUT
        @private_key_file = options[:private_key_file]
        @cert_chain_file = options[:cert_chain_file]
        
        @signature = nil
        @connections = {}
        @on_stop = nil
        @channels = {}
      end
      
      def ssl?
        @private_key_file && @cert_chain_file
      end
      
      def start
        Talker::Server.logger.info "Listening on #{@host}:#{@port}"
        Talker::Server.logger.info "SSL tunnel activated" if ssl?
        
        @signature = EM.start_server(@host, @port, Connection) do |connection|
          connection.server = self
          
          if ssl?
            connection.start_tls :private_key_file => @private_key_file,
                                 :cert_chain_file => @cert_chain_file
          end
          
          connection.comm_inactivity_timeout = @timeout
          
          @connections[connection.signature] = connection
        end

      end
      
      def running?
        !!@signature && EM.reactor_running?
      end
      
      def stop(&callback)
        if running?
          # Stop accepting connections
          EM.stop_server @signature
          @signature = nil
          
          @connections.values.each { |c| c.close_connection_after_writing }
        end
        
        if callback
          if @connections.empty?
            callback.call
          else
            Talker::Server.logger.info "Waiting for #{@connections.size} connections to finish ..."
            @on_stop = callback
          end
        end
      end
      
      def stop!
        if running?
          # Stop accepting connections
          EM.stop_server @signature
          @signature = nil
          
          @connections.values.each { |c| c.close_connection }
        end
      end
      
      def connection_closed(connection)
        # TODO sweep empty channels
        @connections.delete(connection.signature)
        @on_stop.call if @on_stop && @connections.empty?
      end
      
      def channel(type, id)
        name = "#{type}.#{id}"
        @channels[name] || Channel.new(name)
      rescue InvalidChannel
        nil
      end
      
      def authenticate(channel_type, channel_id, token)
        Talker::Server.storage.authenticate(token) do |user|
          # User authentication failed
          if user
            # Channel authorization
            case channel_type
            when "room"
              Talker::Server.storage.authorize_room(user, channel_id) { |room_id| yield channel("room", room_id), user }
            else
              yield channel(channel_type, channel_id), user
            end
            
          else
            yield nil, nil
          
          end
        end
      end
      
      def to_s
        "channel-server:#{@port}"
      end
      
      def self.start(*args)
        s = new(*args)
        s.start
        s
      end
    end
  end
end
