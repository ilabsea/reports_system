set :application, "Symptom Reporting System"
set :scm, :git
set :repository,  "https://github.com/ilabsea/reports_system"
set :scm_passphrase, ""
set :deploy_to, "/var/www/reports_system"
set :deploy_via, :remote_cache
set :user, 'user'
set :group, 'group'

server "", :app, :web, :db, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_configs, :roles => :app do
    %W(settings secrets).each do |file|
      run "ln -nfs #{shared_path}/#{file}.yml #{release_path}/config/"
    end
  end

  task :symlink_data, :roles => :app do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

before "deploy:start", "deploy:migrate"
before "deploy:restart", "deploy:migrate"
after "deploy:update_code", "deploy:symlink_configs"
after "deploy:update_code", "deploy:symlink_data"