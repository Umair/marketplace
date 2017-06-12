require_relative '../lib/checkout'
require_relative '../lib/promotional_rule'
require 'pry'
module MarketplaceSpecHelper

  # define class of product
  class Product
    def initialize (id, name, amount)
      @id = id
      @name = name
      @amount = amount
    end

    attr_accessor :id, :name, :amount
  end

  # define product inventory
  def inventory
    @inventory ||= [
        Product.new("001", "Lavender heart", 9.25),
        Product.new("002", "Personalised cufflinks", 45.00),
        Product.new("003", "Kids T-shirt", 19.95)
    ]
  end

  # If you spend over £60, then you get 10% off your purchase
  def net_discount
    PromotionalRule.new("over_60_pounds") do |items|
      total = items.inject(0) { |sum, item|
        sum + item.amount
      }
      if total > 60
        discount = (total/100 * 10)
      else
        discount = 0
      end
    end
  end

  #  Buy 2 or more lavender hearts , cost will be  £8.50
  def quantity_discount
    PromotionalRule.new("lavender_hearts") do |items|
      # count lavender hearts
      lavender_hearts = items.find_all { |item| item.id == "001" }

      # discount the lavender hearts
      lavender_hearts.each { |lavender_hearts| lavender_hearts.amount = 8.50 } if lavender_hearts.count >= 2

      discount = 0
    end
  end
end