set :rvm_type, :system                     # Defaults to: :auto
set :rvm_ruby_version, '2.4.1'      # Defaults to: 'default'

set :application, "reports_system"
set :scm, :git
set :repo_url,  "https://github.com/ilabsea/reports_system"
set :branch, "master"
set :deploy_to, "/var/www/reports_system"
set :deploy_via, :remote_cache
set :user, 'ilab'



# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/settings.yml','config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'public/uploads')
# Passenger
set :passenger_restart_with_touch, true
