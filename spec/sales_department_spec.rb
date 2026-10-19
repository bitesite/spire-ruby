require 'spec_helper'

RSpec.describe Spire::Inventory::SalesDepartment do
  describe 'find' do
    it 'raises since Spire does not support finding sales departments by id' do
      expect { Spire::Inventory::SalesDepartment.find(10) }.to raise_error(Spire::Error)
    end
  end

  describe 'find_many' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Inventory::SalesDepartment.find_many(limit: 50)
      expect(Spire::BasicData.client).to have_received(:find_many).with(Spire::Inventory::SalesDepartment, '/inventory/sales_departments/', { limit: 50 })
    end
  end

  describe 'search' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Inventory::SalesDepartment.search('Product')
      expect(Spire::BasicData.client).to have_received(:find_many).with(Spire::Inventory::SalesDepartment, '/inventory/sales_departments/', { q: 'Product' })
    end
  end

  describe 'all' do
    it 'calls client.get' do
      allow(Spire::BasicData.client).to receive(:get)
      Spire::Inventory::SalesDepartment.all(1000)
      expect(Spire::BasicData.client).to have_received(:get).with('/inventory/sales_departments/', { limit: 1000 })
    end
  end

  describe 'update_fields' do
    it 'maps camelCase Spire fields onto attributes' do
      department = Spire::Inventory::SalesDepartment.new({})
      department.update_fields('id' => 10, 'code' => '100', 'description' => 'Product', 'revenueAccount' => '41100')

      expect(department.id).to eq(10)
      expect(department.code).to eq('100')
      expect(department.description).to eq('Product')
      expect(department.revenue_account).to eq('41100')
    end
  end
end
