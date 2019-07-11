class NewCsvDataGenerator
  def self.call(path)
    new(path).call
  end

  def initialize(path)
    @path = path
  end

  def call
    generate_new_csv
  end

  private

  def generate_new_csv
    CSV.generate do |csv|
      csv << csv_data[0]
      csv_data.drop(1).each do |datum|
        csv_datum = CsvDatum.new(datum)
        csv << [
          csv_datum.quantity, 
          csv_datum.product,
          csv_datum.sale_string
        ]
      end
    end
  end

  def csv_data
    csv = open(@path).read
    CSV.parse(csv)
  end
end
