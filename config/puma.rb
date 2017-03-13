require "yaml"
require "active_record"

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

environment ENV["RAILS_ENV"]

pidfile "#{shared_dir}/pids/puma.pid"

state_path "#{shared_dir}/pids/puma.state"

stdout_redirect  #{app_dir}/log/development.log, #{app_dir}/log/development.log, true

if ENV["RAILS_ENV"] != "development"
 stdout_redirect "#{ENV['LOG_PATH']}/my-backend.log", "#{ENV['LOG_PATH']}/my-backend.log", true
end

quiet

threads 0, 16

bind "unix:///#{shared_dir}/sockets/puma.sock"

workers (ENV["RAILS_ENV"] == "production") ? ENV["NO_OF_WORKERS"] : 2

on_worker_boot do
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  #ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end

on_worker_shutdown do
    ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
end

preload_app!

tag "my-backend"

worker_timeout 60

activate_control_app "unix:///#{shared_dir}/sockets/pumactl.sock", {no_token: true}
