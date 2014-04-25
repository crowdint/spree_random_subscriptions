Spree::UsersController.class_eval do
  before_action :retrieve_subscriptions, only: [:show]

  private
  def retrieve_subscriptions
    @subscriptions = current_spree_user.subscriptions
  end
end
