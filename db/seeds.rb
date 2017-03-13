Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

products_data = [
  {
    name: "My awesome product",
    meta_title: "My awesome product",
    price: 999,
    slug: "p123",
    properties:{
      "Price Range": "0 - 15000",
      "Category": "Friends",
      "Age": "Upto 30 Days old",
      "type": "product",
      "included_1": "Everything covered",
      "included_2": "Unlimited",
      "included_3": "All costs included",
      "included_4": "Free Home Service",
      "excluded_1": "Physical or cosmetic damages",
      "excluded_2": "Damages caused due to improper usage",
      "excluded_3": "Attachments and accessories"
    }
  }
]

default_shipping_category = Spree::ShippingCategory.find_by_name!("Default")

products_data.each do |product_attrs|
  Spree::Config[:currency] = "INR"
  new_product = Spree::Product.where(name: product_attrs[:name],
                                     tax_category: product_attrs[:tax_category]).first_or_create! do |product|
    product.price = product_attrs[:price]
    product.slug = product_attrs[:slug]
    product.meta_title = product_attrs[:meta_title]
    product.sku = product_attrs[:sku] if product_attrs[:sku]
    product.description = "This is a detail description of this product"
    product.available_on = Time.zone.now
    product.shipping_category = default_shipping_category
  end
end

Spree::Config[:currency] = "INR"
products = {}
products_data.each do |product|
  products[product[:slug]] = Spree::Product.find_by_name!(product[:name])
end

taxonomies = [
  { name: "E1" }
]

taxonomies.each do |taxonomy_attrs|
  Spree::Taxonomy.where(taxonomy_attrs).first_or_create!
end

ew_taxonomy = Spree::Taxonomy.find_by_name!("E1")

taxons = [
  {
    name: "E1",
    taxonomy: ew_taxonomy,
    position: 0,
    products: [
      products['p123']
    ]
  }
]

taxons.each do |taxon_attrs|
  parent = Spree::Taxon.where(name: taxon_attrs[:parent]).first
  taxonomy = taxon_attrs[:taxonomy]
  Spree::Taxon.where(name: taxon_attrs[:name], parent: taxon_attrs[:parent]).first_or_create! do |taxon|
    taxon.parent = parent
    taxon.taxonomy = taxonomy
    taxon.products = taxon_attrs[:products] if taxon_attrs[:products]
  end
end

taxon = Spree::Taxon.where(name: taxons[0][:name]).first
taxon.products = taxons[0][:products]


option_types_attributes = [
  {
    name: "Tenure",
    presentation: "Tenure",
    position: 1
  }
]

option_types_attributes.each do |attrs|
  Spree::OptionType.where(attrs).first_or_create!
end

tenure_option_type = Spree::OptionType.find_by_presentation!("Tenure")

option_values_attributes = [
  {
    name: "1 Year",
    presentation: "1 Year",
    position: 1,
    option_type: tenure_option_type
  },
  {
    name: "2 Year",
    presentation: "2 Year",
    position: 2,
    option_type: tenure_option_type
  }
]

option_values_attributes.each do |attrs|
  Spree::OptionValue.where(attrs).first_or_create!
end

one_year_option_value = Spree::OptionValue.where(name: "1 Year").first
two_year_option_value = Spree::OptionValue.where(name: "2 Year").first

variants = [
  {
    product: products['p123'],
    option_values: [one_year_option_value],
    sku: "p123-1-year",
    cost_price: 1000,
    price: 999
  },
  {
    product: products['p123'],
    option_values: [two_year_option_value],
    sku: "p123-2-year",
    cost_price: 1000,
    price: 1999
  }
]

variants.each do |attrs|
  if Spree::Variant.where(product_id: attrs[:product].id, sku: attrs[:sku]).none?
    Spree::Variant.create!(attrs)
  end
end

Spree::Variant.all.each do |variant|
  next if variant.is_master? && variant.product.has_variants?

  variant.stock_items.each do |stock_item|
    Spree::StockMovement.create(quantity: 1000, stock_item: stock_item)
  end
end


products_data.each do |product_attrs|
  product = Spree::Product.find_by_slug(product_attrs[:slug])
  product_attrs[:properties].each do |prop_name, prop_value|
    product.set_property(prop_name, prop_value)
  end
end
