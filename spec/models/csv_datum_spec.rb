require 'spec_helper'

RSpec.describe CsvDatum do
  let(:csv_datum) { described_class.new(arg) }
  let(:arg)       { ['1', 'books', '12.49'] }

  context 'Initialization' do
    context '@quantity' do
      it 'sets @quantity to Integer' do
        expect(csv_datum.quantity).to be_a Integer
      end

      it 'sets @quantity to correct value' do
        expect(csv_datum.quantity).to eq 1
      end
    end

    context '@product' do
      let(:arg) { ['1,', ' books one   ', '12.49'] }

      it 'removes white spaces' do
        expect(csv_datum.product).to eq 'books one'
      end
    end

    context '@price' do
      it 'sets @price to Float' do
        expect(csv_datum.price).to be_a Float
      end
    end

    context 'initializing with incorrect data' do
      context 'using negative values' do
        let(:arg) { ['-1', 'books', '12.49'] }

        it 'raises an argument error' do
          expect { csv_datum }.to raise_error ArgumentError
        end
      end

      context 'using incorrect data in csv' do
        let(:arg) { ['-1'] }

        it 'raises an argument error' do
          expect { csv_datum }.to raise_error ArgumentError
        end
      end
    end
  end

  context 'Instance Methods' do
    context '#sale_string' do
      context 'with 1 digit no decimal sale price' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:sale)
            .and_return(1)
        end

        it 'returns correct formatting of sale price' do
          expect(csv_datum.sale_string).to be_a String
          expect(csv_datum.sale_string).to eq '1.00'
        end
      end

      context 'with 1 digit and 1 decimal sale price' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:sale)
            .and_return(1.5)
        end

        it 'returns correct formatting of sale price' do
          expect(csv_datum.sale_string).to be_a String
          expect(csv_datum.sale_string).to eq '1.50'
        end
      end
    end

    context 'product not imported and exempted' do
      context '#sale' do
        it 'returns correct sale price' do
          expect(csv_datum.sale).to eq 12.49
        end
      end

      context '#tax' do
        it 'returns correct tax' do
          expect(csv_datum.tax).to eq 0
        end
      end
    end

    context 'product not imported and not exempted' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:tax_exemption?)
          .and_return(false)
      end

      context '#sale' do
        it 'returns correct sale price' do
          expect(csv_datum.sale).to eq 13.74
        end
      end

      context '#tax' do
        it 'returns correct rounded tax' do
          expect(csv_datum.tax).to eq 1.25
        end
      end
    end

    context 'product imported and not exempted' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:imported_good?)
          .and_return(true)
      end

      context '#tax' do
        it 'returns correct rounded tax' do
          expect(csv_datum.tax).to eq 0.65
        end
      end

      context '#sale' do
        it 'returns correct sale price' do
          expect(csv_datum.sale).to eq 13.14
        end
      end
    end

    context 'product imported and exempted' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:imported_good?)
          .and_return(true)
        allow_any_instance_of(described_class)
          .to receive(:tax_exemption?)
          .and_return(false)
      end

      context '#tax' do
        it 'returns correct rounded tax' do
          expect(csv_datum.tax).to eq 1.9
        end
      end

      context '#sale' do
        it 'returns correct sale price' do
          expect(csv_datum.sale).to eq 14.39
        end
      end
    end
  end
end
