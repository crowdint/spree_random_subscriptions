module Spree
  class UpdateCreditCardsController < Spree::StoreController
    before_action :load_subscription

    def edit
      render_edit
    end

    def update
      if params['use_existing_card'] == 'yes'
        process_use_existing_card
      else
        process_use_new_card
      end
    end

    private

    def process_use_existing_card
      if payment_sources.ids.include? params['existing_card'].to_i
        @subscription.update_attribute :credit_card_id, params['existing_card']

        flash[:success] = Spree.t(:credit_card_updated)
        redirect_to account_path
      else
        flash[:error] = Spree.t(:credit_card_doesnt_exist)
        render_edit
      end
    end

    def process_use_new_card
      @credit_card = Spree::CreditCard.new(credit_card_params)

      if @credit_card.valid?
        @credit_card.gateway_customer_profile_id = get_gateway_profile
        @credit_card.user_id = spree_current_user.id

        if @credit_card.save_in_authorize
          @subscription.update_attribute :credit_card_id, @credit_card.id

          flash[:success] = Spree.t(:credit_card_updated)
          redirect_to account_path
        else
          render_edit
        end
      else
        render_edit
      end
    end

    def render_edit
      payment_sources
      render :edit
    end

    def load_subscription
      @subscription = Spree::Subscription.find_by(
        id: params['id'],
        user: spree_current_user
      )
    end

    def payment_sources
      @payment_sources ||= spree_current_user.payment_sources
    end

    def get_gateway_profile
      payment_sources.last.gateway_customer_profile_id
    end

    def credit_card_params
      params.require(:credit_card).permit(:name, :number, :expiry, :verification_value, :cc_type)
    end
  end
end
