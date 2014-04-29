module Spree
  class RenewMailer < BaseMailer
    def send_reminder(subscription)
      @subscription = subscription

      @subject = if subscription.missing_items == 1 
        :subscription_about_to_end
      else
        :subscription_finished
      end

      mail(
        to: subscription.user.email,
        subject: @subject
      )
    end
  end
end
