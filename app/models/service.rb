class Service
  def self.import_entities entity_name, rows
    entity = build_entity(entity_name, rows)

    proceed(entity)
  end

  def self.proceed(entity)
    wit = Wit.new(access_token: Settings.wit['access_token'])

    unless exist? entity['id']
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
          "expressions" => [r[1]]
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

  def self.exist? entity_id
    get_entities().include? entity['id']
  end

  def self.get_entities
    wit = Wit.new(access_token: Settings.wit['access_token'])
    entities = wit.get_entities()
    return entities
  end

end
