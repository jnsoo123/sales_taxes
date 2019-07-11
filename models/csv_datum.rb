class CsvDatum  
  attr_reader :quantity, :product, :price

  def initialize(csv_data)
    @csv_data = csv_data
    arguments_present?   or raise ArgumentError, 'Invalid CSV Data'
    all_positive_values? or raise ArgumentError, 'Invalid Negative Value Found'
    set_attributes
  end

  def tax
    result = price * tax_rate * quantity
    (result * 20).ceil / 20.0
  end

  def sale
    (price * quantity) + tax
  end

  def sale_string
    '%.2f' % sale
  end

  private

  def set_attributes
    @quantity = @csv_data[0].to_i
    @product  = @csv_data[1].strip
    @price    = @csv_data[2].to_f
  end

  def arguments_present?
    @csv_data.length == 3 &&
      @csv_data.all? { |datum| datum.length > 0 }
  end

  def all_positive_values?
    @csv_data[0].to_f > 0 &&
      @csv_data[2].to_f > 0
  end

  def tax_rate
    tax = 0
    tax = tax + 0.10 unless tax_exemption?
    tax = tax + 0.05 if imported_good?
    tax
  end

  def tax_exemption?
    product_to_words.any? do |word|
      PRODUCT_EXEMPTIONS.include? word
    end
  end

  def imported_good?
    product_to_words.any? do |word|
      IMPORT_STRINGS.include? word
    end
  end

  def product_to_words
    @product.split(/\W+/)
  end
end
