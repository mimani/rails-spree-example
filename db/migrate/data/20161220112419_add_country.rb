require 'carmen'

class AddCountry < ActiveRecord::Migration
  def change
    country = Carmen::Country.named("INDIA")
    name            = country.name
    iso3            = country.alpha_3_code
    iso             = country.alpha_2_code
    iso_name        = country.name.upcase
    numcode         = country.numeric_code
    states_required = country.subregions?

    Spree::Country.new(:name => name,
      :iso3 => iso3,
      :iso => iso,
      :iso_name => iso_name,
      :numcode => numcode,
      :states_required => 0 # Making states required as false
    ).save!

    Spree::Config[:default_country_id] = Spree::Country.find_by(iso: "IN").id
  end
end
