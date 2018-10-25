class ActiveApi
  include ActiveApiBase

  cattr_accessor :email, :auth_token

  def self.init_auth options = {}
    @@email = options['email']
    @@auth_token = options['auth_token']
  end
end
