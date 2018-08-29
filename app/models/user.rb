require 'net/http'
class User < ApplicationRecord
  has_secure_password


  def self.request_verboice_authentication(email, password)
    uri = URI(Options.verboice_url + "/api2/auth")
    res = Net::HTTP.post_form(uri, {"account[email]" => email, "account[password]" => password})
    return JSON.parse(res.body)
  end
end
