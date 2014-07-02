module Spree
  class SubscriptionProduct < Product
    attr_accessor :wrap_cost
    attr_accessor :wrap_type

    def subscription?
      true
    end

    def first_month_wrapping?
      name =~ /first mont/
    end


    def self.generate(gender, recurring, wrap_type, limit = nil, price = 11, wrap_cost = 2)
      product = new(
          wrap_cost: wrap_cost,
          name: '',
          description: '',
          limit: limit,
          shipping_category_id: 1,
          available_on: Time.zone.today,
          recurring: recurring
      )

      product.gender = gender
      product.set_recurring(recurring)
      product.original_price = price
      product.wrap = wrap_type
      product.recurring_limit = limit
      product.set_default_stock_items

      product.calculate_price
      product.save
      product
    end

    def self.find_generated(gender, recurring, wrap_type, limit)
      name = "Socks for #{ gender }"
      name += recurring ? " - Pay monthly" : " - Pay once"
      name += " - Wrap #{ wrap_type }" unless wrap_type == 'none'
      name += " - By #{ limit } months" if limit || limit.present?

      find_by(name: name)
    end

    def gender=(gender)
      self.name += "Socks for #{gender}"
      self.description += "- For #{ gender }\n"
    end

    def set_recurring(recurring)
      self.recurring = recurring

      if self.recurring
        self.name += " - Pay monthly"
      else
        self.name += " - Pay once"
      end
    end

    def original_price=(price)
      self.price = price
      self.description += "- Price: $#{price}\n"
    end

    def wrap=(wrap)
      unless wrap == 'none'
        self.name += " - Wrap #{ wrap }"

        if wrap == 'first month' || !limit
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
      self.price += @wrap_cost if @wrap_type == 'every month'

      unless recurring
        self.price *= self.limit
        self.price += @wrap_cost if @wrap_type == 'first month'
      end
    end

    def wrap_every_month?
      name =~ /every month/
    end
  end
end
