module Spree
  class SubscriptionProduct < Product
    attr_accessor :wrap_cost
    attr_accessor :wrap_type

    def subscription?
      true
    end

    def self.generate(gender, recurring, wrap_type, limit = nil, price = 11, wrap_cost = 2)
      product = new(
        recurring: recurring,
        wrap_cost: wrap_cost,
        name: '',
        description: '',
        limit: limit,
        shipping_category_id: 1
      )

      product.gender = gender
      product.original_price = price
      product.wrap = wrap_type
      product.recurring_limit = limit

      product.calculate_price
      product.save
      product
    end

    def original_price=(price)
      self.price = price
      self.description += "- Price: $#{price}\n"
    end

    def gender=(gender)
      self.name += "Socks for #{gender}"
      self.description += "- For #{ gender }\n"
    end

    def wrap=(wrap)
      unless wrap == 'none'
        self.name += " - Wrap #{ wrap }"

        if wrap == 'first month'
          self.description += "- Wrap #{ wrap } $#{ wrap_cost}\n"
        else
          self.description += "- Wrap #{ wrap } $#{ wrap_cost } X #{ limit } = $#{ wrap_cost * limit }\n"
        end
      end

      @wrap_type = wrap
    end

    def recurring_limit=(limit)
      self.limit = limit
      self.name += " - By #{ limit } months" if limit
    end

    def calculate_price
      if recurring
        self.price += @wrap_cost if @wrap_type == 'every month'
        self.price *= limit
      end

      self.price += @wrap_cost if @wrap_type == 'first month'
    end
  end
end
