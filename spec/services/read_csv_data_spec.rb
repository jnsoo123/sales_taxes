require 'spec_helper'

RSpec.describe ReadCsvData do
  let(:test_file) do
    test_data = [
      ['Quantity','Product','Price'],
      ['1','books','12.49'],
      ['1','music cd','14.99'],
      ['1','chocolate bar','0.85']
    ]

    Tempfile.new(['csv', '.csv']).tap do |f|
      test_data.each do |datum|
        f << datum.join(',') + "\n"
      end

      f.close
    end
  end
after do
    test_file.unlink
  end

  context 'Class Method' do
    context 'With correct data' do
      context '#call' do
        it 'returns pased csv data' do
          result = described_class.call(test_file.path)
          expected_result = [
            ['1','books','12.49'],
            ['1','music cd','14.99'],
            ['1','chocolate bar','0.85']
          ]
          expect(result).to eq expected_result
        end
      end
    end

    context 'With incorrect data' do
      let(:test_file) do
        test_data = [
          ['Quantity','Product','Price'],
          ['1','books','12.49'],
          ['1','music cd','14.99'],
          ['1','chocolate bar','0.85']
        ]

        Tempfile.new(['csv', '.invalid_ext_name']).tap do |f|
          test_data.each do |datum|
            f << datum.join(',') + "\n"
          end

          f.close
        end
      end

      context '#call' do
        it 'raises an argument error' do
          expect { described_class.call(test_file.path) }
            .to raise_error(ArgumentError)
        end

        it 'also raises an argument error if path does not exist' do
          expect { described_class.call('invalid_path.csv') }
            .to raise_error(ArgumentError)
        end
      end
    end
  end
end
