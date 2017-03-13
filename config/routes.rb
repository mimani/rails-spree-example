Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.add_routes do
     namespace :api, defaults: { format: 'json' } do
    end
  end
end
