module ActiveApiBase
  extend ActiveSupport::Concern
 
  included do
    require "addressable/uri"
    include Virtus.model
    extend  ActiveModel::Naming
    extend  ActiveModel::Translation
    include ActiveModel::Conversion
    include ActiveModel::Validations
  end
 
  def persisted?
    id.present?
  end

  def assign_errors(error_data)
    error_data[:errors].each do |attribute, attribute_errors|
      attribute_errors.each do |error|
        self.errors.add(attribute, error)
      end
    end
  end

  module ClassMethods
    def query_string parameters
      parameters.reject!{ |key, value| value.blank? }

      Addressable::URI.new.tap do |uri|
        uri.query_values = parameters
      end.query
    end

    def where(parameters={})
      query = query_string parameters

      response = Typhoeus.get("#{base_url}?#{query}", body: embed(),  headers: {"Accept" => "application/json"})
      if response.success?
        data = JSON.parse(response.body, symbolize_names: true)
        return data.map{ |record| self.new(record) }
      else
        raise 'Could not connect to remote server'
      end
    end
 
    alias_method :all, :where
 
    def update(id, attributes={}, action = nil)
      object = self.new(attributes.merge(id: id))
      url = action.nil? ? "#{base_url}/#{id}" : "#{base_url}/#{id}/#{action}"
      response = Typhoeus::Request.put(url, body: embed(attributes).to_json, headers: {"content-type" => "application/json"})
      if response.response_code == 422
        data = JSON.parse(response.body, symbolize_names: true)
        object.assign_errors(data)
      end

      return object
    end
 
    def embed(attributes={})
      params = attributes.merge({email: ActiveApi.email, token: ActiveApi.auth_token})
      params
    end
 
    def base_url
      URI.join(Settings.verboice['url'], endpoint_url).to_s
    end
 
  end
end
