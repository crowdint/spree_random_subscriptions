class Spree::SilentPostController < ApplicationController
  def create
    if params[:x_response_code] == '1'
      subscription = Spree::Subscription.find_by_x_subscription_id(params['x_subscription_id'])
      subscription.try(:create_order)
    end

    render nothing: true
  end
ond
