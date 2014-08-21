module Spree
  class AddressesController < Spree::StoreController
    before_action :address_params, only: :update
    before_action :find_address

    def edit
      @states = State.all
      @countries = Country.all
    end

    def update
      if @address.update(address_params)
        redirect_to account_path,
          notice: 'Address updated successfully'
      else
        render :edit
      end
    end

    private

    def address_params
      params.require(:address).permit(
        :firstname,
        :lastname,
        :address1,
        :city,
        :country_id,
        :state_id,
        :state_name,
        :zipcode,
        :phone
      )
    end

    def find_address
      @address = current_spree_user.subscriptions.find(params[:subscription_id]).address
    end
  end
end
