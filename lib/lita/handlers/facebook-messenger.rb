require "json"

module Lita
  module Handlers
    class FacebookMessenger < Handler
      http.post 'facebook' do |request, response|
        params = JSON.parse(request.body.read)
        puts params.inspect

        params['entry'.freeze].each do |entry|
          # Facebook may batch several items in the 'messaging' array during
          # periods of high load.
          entry['messaging'.freeze].each do |messaging|
            Facebook::Messenger::Bot.receive(messaging)
          end
        end

        # if params['token'] != config.token
        #   response.status = 401
        # else
        #   subdomain, sender, vchannel, username, text = params.values_at(*INNEED_PARAMS)
        #   # Creates a new room with the given ID, or merges and saves supplied
        #   user = Lita::User.create(sender, {
        #     name: username,
        #     subdomain: subdomain
        #   })
        #   source = Lita::Source.new(user: user, room: vchannel)
        #   message = Lita::Message.new(robot, format_text(text.to_s), source)
        #   robot.receive(message)
        # end


        response.finish
      end

      private
      def format_text(text)
        mention_string = "@#{robot.mention_name}"
        text.index(mention_string) ? text : "#{mention_string} #{text}"
      end

    end
    Lita.register_handler(FacebookMessenger)
  end
end
