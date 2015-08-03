class Echo
  class Response
    def initialize saying, card: nil
      @saying = saying
      @card   = card
    end

    def to_h
      h = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "PlainText",
            text: @saying
          }
        },
        shouldEndSession: true
      }
      h[:card] = @card.merge(type: "Simple") if @card
      h
    end

    def to_json
      to_h.to_json
    end
  end
end
