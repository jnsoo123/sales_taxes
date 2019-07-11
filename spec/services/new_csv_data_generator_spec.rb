require 'spec_helper'

RSpec.describe NewCsvDataGenerator do
  context 'Class Methods' do
    context '#call' do
      let(:test_file) do
        test_data = [
          ['Quantity','Product','Price'],
          ['1', 'imported bottle of perfume', '27.99'],
          ['1', 'bottle of perfume', '18.99'],
          ['1', 'packet of headache pills', '9.75'],
          ['1', 'box of imported chocolates', '11.25'],
        ]

        Tempfile.new('csv').tap do |f|
          test_data.each do |datum|
            f << datum.join(',') + "\n"
          end

          f.close
        end
      end

      it 'generates new csv with computed sale price with tax' do
        result = described_class.call(test_file.path)
        expected_result = 
          %q(Quantity,Product,Price
1,imported bottle of perfume,32.19
1,bottle of perfume,20.89
1,packet of headache pills,9.75
1,box of imported chocolates,11.85
)
        expect(result).to eq expected_result
      end
    end
  end
end
