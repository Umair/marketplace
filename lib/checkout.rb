#==== Checkout class for interface
class Checkout
  def initialize(inventory, promotional_rules=[])
    @inventory = inventory
    @promotional_rules = promotional_rules
  end

# @param [Product] object of product class
#
# @return [Array] returns array of products objects
  def scan (item)
    items.push(item)
  end

# @return total amount after applying promotional rules discounts
  def total
    discount = 0

    # apply discounts according to promotional rules
    @promotional_rules.each { |i| discount += i.get_discount(items) }

    total = items.inject(0) { |s, item| s + item.amount } - discount
    # round to pennies
    (total*100).round / 100.0
  end

  private
  def items
    @items ||= []
  end
end