require "spec_helper"

describe Spree::RenewMailer do
  describe '#send_reminder' do
    let(:subscription) { create :subscription }
    let(:mail) { described_class.send_reminder(subscription) }

    it 'contains renew url' do
      expect(mail.body).to include '/renew/'
    end
  end
end
