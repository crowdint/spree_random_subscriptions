require 'spec_helper'

module Spree
  module Stock
    module Splitter
      describe Address do
        let(:line_item1) { create :line_item_with_address }
        let(:line_item2) { create :line_item_with_address }

        let(:packer) { build(:stock_packer) }

        subject { Address.new(packer) }

        let(:package) do
          package = Package.new(packer.stock_location, packer.order)
          package.add line_item1, 1, :on_hand
          package.add line_item2, 1, :on_hand
          package
        end

        let(:packages) { subject.split([package]) }

        it 'splits each package by address' do
          expect(packages.size).to eq(2)
        end

        it 'asssings the line item 1 to the first package' do
          expect(packages.first.contents.first.line_item).to eq line_item1
        end

        it 'asssings the line item 2 to the last package' do
          expect(packages.last.contents.first.line_item).to eq line_item2
        end
      end
    end
  end
end

