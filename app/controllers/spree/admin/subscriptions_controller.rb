module Spree
  module Admin
    class SubscriptionsController < Spree::Admin::BaseController
      before_action :load_subscription, only: :destroy

      def index
        @subscriptions = Spree::Subscription.all
      end

      def destroy
        @subscription.cancel
        redirect_to spree.admin_subscriptions_path
      end

      private
      def load_subscription
        @subscription ||= Spree::Subscription.find_by_id params[:id]
      end
    end
  end
end

