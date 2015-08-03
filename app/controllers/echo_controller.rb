class EchoController < ApplicationController
  def respond
    intent = params[:command][:request][:intent]
    count  = params[:slots][:Count][:value]

    Slack.pug_bomb count: count

    render json: Echo::Response.new("Ok ... #{count} pugs incoming")
  end
end
