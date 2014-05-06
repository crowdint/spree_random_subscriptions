module Spree
  module Stock
    module Splitter
      class Address < Base

        def split(packages)
          split_packages = []
          packages.each do |package|
            split_packages += split_by_address(package)
          end
          return_next split_packages
        end

        private
        def split_by_address(package)
          addresses = Hash.new { |hash, key| hash[key] = [] }
          package.contents.each do |item|
            address_id = item.line_item.ship_address.try(:id)
            addresses[address_id] << item
          end
          build_packages addresses
        end

        def build_packages(addresses)
          packages = []
          addresses.each do |id, contents|
            packages << build_package(contents)
          end
          packages
        end

      end
    end
  end
end

