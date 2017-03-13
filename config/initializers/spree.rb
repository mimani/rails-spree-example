Spree.config do |config|
 config[:currency] = "INR"
 config[:address_requires_state] = false
 config[:admin_interface_logo] = "logo/spree_50.svg"
end

Spree.user_class = "Spree::User"
Spree::Api::Config[:requires_authentication] = false
