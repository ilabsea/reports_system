class Service

  def self.import_entities entities_name, rows
    if get_entities().include? entities_name
      update_entities(entities_name, rows)
    else
      create_entities(entities_name, rows)
    end
  end

  def self.create_entities entities_name, rows
    wit = Wit.new(access_token: Options.wit_token)
    values = []
    rows.each do |r|
      if r[0] != nil
        values << {
                    "value" => "#{r[0]}",
                    "expressions" => 
                      [ r[0]]
                  }
      end
    end
    new_entity_obj = {
                        "doc" => "Value number of #{entities_name}",
                        "id" => entities_name,
                        "values" => values
                      }
    new_entity = wit.post_entities(new_entity_obj)
  end

  def self.update_entities entities_name, rows
    wit = Wit.new(access_token: Options.wit_token)
    values = []
    rows.each do |r|
      if r[0] != nil
        values << {
                    "value" => "#{r[0]}",
                    "expressions" => 
                      [ r[0]]
                  }
      end
    end
    new_entity_obj = {
                        "doc" => "Value number of #{entities_name}",
                        "id" => entities_name,
                        "values" => values
                      }
    new_entity = wit.put_entities(entities_name, new_entity_obj)
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
    wit = Wit.new(access_token: Options.wit_token)
    entities = wit.get_entities()
    return entities
  end

  def self.request_report(email, auth_token, params)
    uri = URI(Options.verboice_url + "/plugin/reports/api2/reports")
    params[:email] = email
    params[:token] = auth_token 
    uri.query = URI.encode_www_form(params)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end

end