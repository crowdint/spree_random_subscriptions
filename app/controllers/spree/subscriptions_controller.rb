module Spree
  class SubscriptionsController < Spree::StoreController
    def show
      @subscription = Subscription.find(params[:id])
    end
  end
end
