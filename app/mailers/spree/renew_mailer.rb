module Spree
  class RenewMailer < BaseMailer
    def send_reminder(subscription)
      @subscription = subscription

      if subscription.missing_items == 1
        @subject = :subscription_about_to_end
      else
        @subject = :subscription_finished
      end

      mail(
        to: subscription.user.email,
        subject: @subject
      )
    end
  end
end
