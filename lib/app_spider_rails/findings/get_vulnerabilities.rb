module AppSpiderRails
  module Findings
    class GetVunlerabilities
      def initialize(connection)
        @connection = connection
      end

      def get
        Response.new(connection.get("/Findings/GetVunlerabilities"))
      end

      private

      attr_reader :connection
    end
  end
end
