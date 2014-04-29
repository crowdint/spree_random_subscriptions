module Spree
  module Admin
    class SubscriptionsController < Spree::Admin::BaseController
      def index
        @subscriptions = Spree::Subscription.all
      end
    end
  end
end

