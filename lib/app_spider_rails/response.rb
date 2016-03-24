module AppSpiderRails
  class Response
    attr_reader :raw
    attr_reader :message

    def initialize(raw)
      @raw     = raw
      @message = parsed
    end

    def successful?
      raw.code == "200"
    end

    def failed?
      raw.code != "200"
    end

    private

    def parsed
      return {} unless raw&.body
      JSON.parse raw.body
    end
  end
end
