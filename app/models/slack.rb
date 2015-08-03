class Slack
  Token = ENV.fetch "SLACK_API_TOKEN"

  include HTTParty
  base_uri "https://slack.com/api"

  def self.send_message text:, channel:
    post "/chat.postMessage", body: {
      token:    Token,
      channel:  channel,
      text:     text,
      as_user:  true
    }
  end

  def self.pug_bomb channel:, count: 3
    response = HTTParty.get("http://pugme.herokuapp.com/bomb", query: { count: count })
    response["pugs"].each { |url| send_message text: url, channel: channel }
  end

  class Session
    def initialize channel: nil
      resp           = Slack.post "/rtm.start", body: { token: Token }
      websocket_url  = resp["url"]

      @ws = Faye::WebSocket::Client.new websocket_url, nil, ping: 15
      @ws.on(:close) { |event| @ws = nil }
    end

    def on_message
      @ws.on :message do |event|
        m = JSON.parse(event.data).with_indifferent_access
        yield m if m[:type] == "message"
      end
    end
  end
end
