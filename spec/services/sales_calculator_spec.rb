require 'spec_helper'

RSpec.describe SalesCalculator do
  arg_1 = [
    ['1','books','12.49'],
    ['1','music cd','14.99'],
    ['1','chocolate bar','0.85']
  ]

  arg_2 = [
    ['1', 'imported box of chocolates', '10.00'],
    ['1', 'imported bottle of perfume', '47.50']
  ]

  arg_3 = [
    ['1', 'imported bottle of perfume', '27.99'],
    ['1', 'bottle of perfume', '18.99'],
    ['1', 'packet of headache pills', '9.75'],
    ['1', 'box of imported chocolates', '11.25'],
  ]

  expected_results = {
    0 => {
      total_tax: '1.50',
      total: '29.83'
    },
    1 => {
      total_tax: '7.65',
      total: '65.15'
    },
    2 => {
      total_tax: '6.70',
      total: '74.68'
    }
  }

  [arg_1, arg_2, arg_3].each_with_index do |arg, index|
    context 'Initialization' do
      it 'sets correct @data' do
        calculator = described_class.new(arg)
        data = calculator.instance_variable_get('@data')
        expect(data).to eq arg
      end

      context 'calculates the total sale and tax' do
        it 'calculates correct @total_tax' do
          calculator = described_class.new(arg)
          total_tax = calculator.instance_variable_get('@total_tax')
          total_tax = '%.2f' % total_tax
          expect(total_tax).to eq expected_results[index][:total_tax]
        end

        it 'calculates correct @total' do
          calculator = described_class.new(arg)
          total = calculator.instance_variable_get('@total')
          total = '%.2f' % total
          expect(total).to eq expected_results[index][:total]
        end
      end
    end

    context 'Instance Variables' do
      context '#total_tax' do
        it 'returns correct rounded off tax' do
          calculator = described_class.new(arg)
          expect(calculator.total_tax)
            .to eq expected_results[index][:total_tax]
        end
      end

      context '#total' do
        it 'returns correct rounded off tax' do
          calculator = described_class.new(arg)
          expect(calculator.total)
            .to eq expected_results[index][:total]
        end
      end
    end
  end
end
