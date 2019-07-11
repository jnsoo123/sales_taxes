class SalesCalculator
  def initialize(csv_data)
    @data = csv_data
    @total_tax = 0
    @total = 0
    calculate_sales
  end

  def total_tax
    '%.2f' % @total_tax
  end

  def total
    '%.2f' % @total
  end

  private

  def calculate_sales
    @data.each do |datum|
      csv_datum = CsvDatum.new(datum)

      @total_tax += csv_datum.tax
      @total     += csv_datum.sale
    end
  end
end
