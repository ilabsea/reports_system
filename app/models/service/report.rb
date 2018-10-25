class Service::Report < ActiveApi
  attribute :id, Integer
  attribute :call_id, Integer
  attribute :message, String
  attribute :properties, Array
  attribute :location, String
  attribute :address, String
  attribute :created_at, String

  def self.endpoint_url
    '/plugin/reports/api2/reports'
  end

  def readable_report
    reports = []
    properties.each do |property|
      unless property.empty?
        report_readables = []
        report_readables.push "case:#{property[Settings.wit['case_key'].to_sym]}"
        
        if property[Settings.wit['symptoms_key'].to_sym] && property[Settings.wit['symptoms_key'].to_sym].is_a?(Array)
          symptoms = property[Settings.wit['symptoms_key'].to_sym].map { |s| s }
          report_readables.push "symptom:#{symptoms}"
        end

        reports.push report_readables.join(', ')
      end
    end
    reports.join("; ")
  end
end
