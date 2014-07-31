module Spree
  class SubscriptionsController < Spree::StoreController
    def show
      @subscription = current_spree_user.subscriptions.find(params[:id])
    end
  end
end
