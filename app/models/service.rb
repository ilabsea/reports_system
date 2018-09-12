require 'net/http'
class Service

  def self.import_entities entity_name, rows
    entity = build_entity(entity_name, rows)

    proceed(entity)
  end

  def self.proceed(entity)
    wit = Wit.new(access_token: Settings.wit_token)

    if get_entities().include? entity['id']
      wit.post_entities(entity)
    else
      wit.put_entities(entity['id'], entity)
    end
  end

  def self.build_entity(entity_name, rows)
    values = []

    rows.each do |r|
      if r[0] != nil
        values << {
          "value" => "#{r[0]}",
          "expressions" => [r[0]]
        }
      end
    end

    {
      "doc" => "Value number of #{entity_name}",
      "id" => entity_name,
      "values" => values
    }
  end

  def self.read_sheet spreadsheet, index
    sheet = spreadsheet.worksheet index.to_i
    return sheet.rows
  end

  def self.save_excel file_obj
    file_name = random_string file_obj.original_filename
    file_path = generate_file_path file_name
    File.open(file_path, "wb") do |file|
      file.write(file_obj.read)
    end
    return file_name
  end

  def self.random_string file_name
    @string ||= "#{SecureRandom.urlsafe_base64}-#{file_name}"
  end

  def self.generate_file_path file_name
    return Rails.root.join('public', 'uploads', file_name)
  end

  def self.get_entities
    wit = Wit.new(access_token: Settings.wit_token)
    entities = wit.get_entities()
    return entities
  end

  def self.request_report(email, auth_token, params)
    uri = URI(Settings.verboice_url + "/plugin/reports/api2/reports")
    params[:email] = email
    params[:token] = auth_token 
    uri.query = URI.encode_www_form(params)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end

  def self.request_verboice_authentication(email, password)
    uri = URI(Settings.verboice_url + "/api2/auth")
    res = Net::HTTP.post_form(uri, {"account[email]" => email, "account[password]" => password})
    return JSON.parse(res.body)
  end

end
