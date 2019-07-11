require_relative 'init'

csv_file = ARGV[0]

begin
  csv_data   = ReadCsvData.call(csv_file)
  calculator = SalesCalculator.new(csv_data)
  new_csv    = NewCsvDataGenerator.call(csv_file)

  puts new_csv
  puts ''
  puts "Sales Taxes: #{calculator.total_tax}"
  puts "Total: #{calculator.total}"
rescue ArgumentError => e
  puts "Error: #{e.message}"
rescue StandardError => e
  puts "Error: #{e.message}"
end
