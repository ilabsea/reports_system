class Session
  cattr_accessor :success, :credential

  def self.login email, password
    url = Settings.verboice['url'] + '/api2/auth'
    response = Typhoeus::Request.post(url, body: {account: {email: email, password: password} }, headers: {"Accept" => "application/json"} )
    if response.success?
      @@success = true
      JSON.parse(response.body, symbolize_names: true)
    else
      @@success = false
      if response.code == 401
        JSON.parse(response.body, symbolize_names: true)
      elsif response.code == 404
        {success: false, message: 'Page not found'}
      else
        {success: false, message: 'Unknown Error'}
      end
    end
  end

  def self.success?
    @@success
  end

end
