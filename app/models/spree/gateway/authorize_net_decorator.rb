Spree::Gateway::AuthorizeNet.class_eval do
  def capture(money, authorization, options = {})
    if subscription.monthly?
      recurring(money, creditcard, options)
    else
      super(money, creditcard, options)
    end
  end

  def purchase(money, creditcard, options = {})
    if subscription.monthly?
      recurring(money, creditcard, options)
    else
      super(money, creditcard, options)
    end
  end
end