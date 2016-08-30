module Lita
  module Adapters
    class FacebookMessenger < Adapter
      include Facebook::Messenger
      attr_reader :client

      config :facebook_access_token, type: String, required: true
      config :facebook_app_secret, type: String, required: true
      config :facebook_verify_token, type: String, required: true

      def initialize(robot)
        super

        Facebook::Messenger.configure do |fb_config|
          fb_config.access_token = config.facebook_access_token
          fb_config.app_secret = config.facebook_app_secret
          fb_config.verify_token = config.facebook_verify_token
        end
      end

      def run
        Bot.on :message do |message|
          log.debug "#{message.inspect}"
          message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
          message.sender      # => { 'id' => '1008372609250235' }
          message.seq         # => 73
          message.sent_at     # => 2016-04-22 21:30:36 +0200
          message.text        # => 'Hello, bot!'
          message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

          user_id = message.sender['id']
          user = Lita::User.find_by_name(user_id)
          unless user
            metadata = {} # {name: message.from.username, first_name: message.from.first_name, last_name: message.from.last_name}
            user = Lita::User.create(user_id, metadata)
          end

          chat = Lita::Room.new(user_id)
          source = Lita::Source.new(user: user, room: chat)


          if message.attachments.present?
            attachment = message.attachments.first
            if attachment && attachment["type"] == "location"
              text = "/location #{attachment["payload"]["coordinates"]["lat"]} #{attachment["payload"]["coordinates"]["long"]}"
            end
          else
            text = message.text
          end

          unless text.nil?
            msg = Lita::Message.new(robot, text, source)
            log.info "Incoming Message: text=\"#{text}\" uid=#{source.room}"
            robot.receive(msg)
          else
            log.debug "Incoming Message with no content"
          end

          # Bot.deliver(
          #   recipient: message.sender,
          #   message: {
          #     text: 'Hello, human!'
          #   }
          # )
        end

        Bot.on :postback do |message|
          log.info "---> #{message.inspect}"

          user_id = message.sender['id']
          user = Lita::User.find_by_name(user_id)
          unless user
            metadata = {} # {name: message.from.username, first_name: message.from.first_name, last_name: message.from.last_name}
            user = Lita::User.create(user_id, metadata)
          end

          chat = Lita::Room.new(user_id)
          source = Lita::Source.new(user: user, room: chat)
          msg = Lita::Message.new(robot, message.payload, source)
          log.info "Incoming Message: text=\"#{message.payload}\" uid=#{source.room}"
          robot.receive(msg)

          # Bot.deliver(
          #   recipient: message.sender,
          #   message: {
          #     text: 'Hello, human!'
          #   }
          # )
        end
        sleep
      end

      def send_messages(target, messages)
        opts = messages.pop if messages.last.is_a? Hash
        messages.each do |message|
          if message == messages.last && opts
            if opts[:keyboard].present?
              message_data = {
                  attachment: {
                    type: 'template',
                    payload: {
                      template_type: 'button',
                      text: message,
                      buttons: opts[:keyboard].map{|b| b.is_a?(Hash) ? b : { type: 'postback', title: b, payload: b } }
                    }
                  }
                }
            end
          end

          message_data ||= { text: message }

          log.debug "outgoing message: #{message_data.inspect}"

          Bot.deliver(
            recipient: {
              id: target.room
            },
            message: message_data
          )
        end
      end

      Lita.register_adapter(:facebook_messenger, self)
    end
  end
end
