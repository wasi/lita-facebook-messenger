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
