Spree ADMIN UI and Backend API for Awesome website

Setup for Development:
---------------------

A) Installing Spree Gems

Currently we dont have gem repo, so to install spree patched gem follow this step

* bundle install
* bundle exec rake gem:build
* bundle exec rake gem:install

B) Configuring Website Backend


* Ensure database configurations are updated in database.yml file
* bundle install
* rake db:create
* rake db:migrate
* rake db:seed

C) Start sever by rails s
