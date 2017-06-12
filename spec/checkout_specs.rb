require File.dirname(__FILE__) + '/marketplace_spec_helper'
include MarketplaceSpecHelper

describe Checkout, 'Bill' do

  before(:all) do
    @item1 = inventory[0]
    @item2 = inventory[1]
    @item3 = inventory[2]
  end

  context "Checkout class object tests" do
    let(:checkout) { Checkout.new(inventory) }
    it "object should be Checkout class" do
      expect(checkout).to be_instance_of(Checkout)
    end

    it "object should have instance method scan" do
      expect(checkout.methods.include?(:scan)).to be true
    end

    it "object should have instance method total" do
      expect(checkout.methods.include?(:total)).to be true
    end

    it "Object should have private instance method items" do
      expect(checkout.methods.include?(:items)).to be false
    end
  end

  context "No promotional rules" do
    let(:checkout) { Checkout.new(inventory) }
    it "total should be 0" do
      expect(checkout.total).to equal(0.0)
    end
    it "total should be price of one item" do
      checkout.scan(@item1)
      expect(checkout.total).to equal(9.25)
    end
    it "total should be 2 times of same item price" do
      checkout.scan(@item1)
      checkout.scan(@item1)
      expect(checkout.total).to equal(18.5)
    end
    it "total should be price of 2 items" do
      checkout.scan(@item1)
      checkout.scan(@item2)
      expect(checkout.total).to equal(54.25)
    end

    it 'total should be price of 3 items' do
      checkout.scan(@item1)
      checkout.scan(@item2)
      checkout.scan(@item3)
      expect(checkout.total).to equal(74.2)
    end
  end

  context "with promotional rules" do

    let(:promotional_rules) { [net_discount, quantity_discount] }

    let(:checkout) { Checkout.new(inventory,promotional_rules) }

    # basket: 001,002,003
    # 9.25 = 9.25
    # No promotional discount should be applied
    # Total price expected: £9.25

    it "total should be correct price for one item" do
      checkout.scan(@item1)
      expect(checkout.total).to equal(9.25)
    end

    # basket: 001,002,003
    # 45 + 19.95 = 64.95 - 10% = 58.455
    # No promotional discount will should be applied
    # Total price expected: £58.46

    it "total should be price for two items" do
      checkout.scan(@item2)
      checkout.scan(@item3)
      expect(checkout.total).to equal(58.46)
    end

    # basket: 001,002,003
    # 9.25 + 45 + 19.95 = 74.2 - 10% = 66.78
    # Total price will have net amount promotion ( total above £60)
    # Total price expected: £66.78

    it "total should be 66.78 with a basket of 001,002,003" do
      basket = [@item1,@item2,@item3]
      basket.each {|item| checkout.scan(item) }
      expect(checkout.total).to equal(66.78)
    end

    # basket: 001,003,001
    # 8.50 + 19.95 + 8.50 = 36.95
    # Total will have quantity_discount (Lavender heart) promotion
    # Total price expected: £36.95

    it "total should be 36.95 with a basket of 001 003 001" do
      basket = [@item1,@item3,@item1]
      basket.each {|item| checkout.scan(item) }
      expect(checkout.total).to equal(36.95)
    end

    # basket: 001,002,001,003
    # Total price expected: £73.76
    it "total should be 73.76 with a basket of 001 002 001 003" do
      basket = [@item1,@item2,@item1,@item3]
      basket.each {|item| checkout.scan(item)}
      expect(checkout.total).to equal(73.76)
    end


  end
end