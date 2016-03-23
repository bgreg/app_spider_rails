module AppSpiderRails
  class User
    attr_accessor :username, :password, :auth_token
    def initialize(username, password)
      @username = username
      @password = password
    end
  end
end
