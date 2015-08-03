#!/usr/bin/env rails runner

EM.run {
  session = Slack::Session.new
  session.on_message do |msg|
    case msg[:text]
    when /pug me/i
      Slack.pug_bomb channel: msg[:channel], count: 1
    when /pug bomb (\d+)/i
      Slack.pug_bomb channel: msg[:channel], count: $1.to_i
    when /pug bomb/i
      Slack.pug_bomb channel: msg[:channel]
    end
  end

  puts "Slackbot running"
  Slack.send_message text: "Hello World!", channel: ENV["SLACK_CHANNEL"]
}
