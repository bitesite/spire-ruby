require 'spec_helper'

RSpec.describe Spire::AR::Transaction do
  let(:transaction) { Spire::AR::Transaction.new("id" => 55, "transType" => "P", "customer" => { "id" => 214 }) }

  describe 'find' do
    it 'calls client.find' do
      allow(Spire::BasicData.client).to receive(:find)
      Spire::AR::Transaction.find(1)
      expect(Spire::BasicData.client).to have_received(:find).with('/ar/transactions', 1, {})
    end
  end

  describe 'search' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::AR::Transaction.search("0000123")
      expect(Spire::BasicData.client).to have_received(:find_many).with(Spire::AR::Transaction, '/ar/transactions/', { q: "0000123" })
    end
  end

  describe 'find_many' do
    it 'calls client.find_many with params' do
      allow(Spire::BasicData.client).to receive(:find_many)
      filter = { transType: "I", transNo: "0000123" }.to_json
      Spire::AR::Transaction.find_many(filter: filter)
      expect(Spire::BasicData.client).to have_received(:find_many).with(Spire::AR::Transaction, '/ar/transactions/', { filter: filter })
    end
  end

  describe 'create' do
    it 'posts the payload to Spire and returns the transaction with its new id' do
      allow(Spire::BasicData.client).to receive(:post).and_return({ id: "99" }.to_json)

      created = Spire::AR::Transaction.create(
        customer: { "id" => 214 },
        trans_type: Spire::AR::Transaction::PAYMENT,
        credit_amt: "25.00",
        payment_method: 3,
        date: "2026-10-09",
        reference_no: "CHQ-1",
      )

      expect(Spire::BasicData.client).to have_received(:post).with(
        '/ar/transactions/',
        {
          customer: { "id" => 214 },
          date: "2026-10-09",
          transType: "P",
          referenceNo: "CHQ-1",
          creditAmt: "25.00",
          paymentMethod: 3,
        }
      )
      expect(created).to be_a(Spire::AR::Transaction)
      expect(created.id).to eq "99"
    end
  end

  describe 'save' do
    it 'raises when the transaction already exists' do
      expect { transaction.save }.to raise_error(Spire::Error)
    end
  end

  describe 'apply' do
    it 'posts to the apply endpoint' do
      allow(transaction.client).to receive(:post)
      transaction.apply(10)
      expect(transaction.client).to have_received(:post).with('/ar/transactions/55/apply/10')
    end

    it 'includes the amount for partial applies' do
      allow(transaction.client).to receive(:post)
      transaction.apply(10, "12.50")
      expect(transaction.client).to have_received(:post).with('/ar/transactions/55/apply/10?amount=12.50')
    end
  end

  describe 'update_fields' do
    it 'maps camelCase API fields to attributes' do
      parsed = Spire::AR::Transaction.new("id" => 7, "transType" => "I", "transNo" => "0000123", "balance" => "100.00", "customer" => { "id" => 214 })
      expect(parsed.trans_type).to eq "I"
      expect(parsed.trans_no).to eq "0000123"
      expect(parsed.balance).to eq "100.00"
      expect(parsed.invoice?).to be true
      expect(parsed.payment?).to be false
    end
  end

  describe 'client path resolution' do
    it 'resolves /ar/transactions to Spire::AR::Transaction' do
      expect(Spire::Client.new.send(:class_from_path, '/ar/transactions')).to eq Spire::AR::Transaction
    end
  end
end
