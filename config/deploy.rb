default_run_options[:pty] = true
#ssh_options[:forward_agent] = true

# Overwrite the default deploy start/stop/restart actions with passenger ones
require 'config/deploy/passenger'
require 'lib/capistrano/remote_sync'
require 'capistrano/ext/multistage'
require 'bundler'
require 'bundler/capistrano'
set :bundle_without,  [:development, :test]

set :repository,  "git@github.com:LRDesign/test-r3.git"
# set :deploy_via, :remote_cache
set :scm, 'git'
# set :git_shallow_clone, 1
set :scm_verbose, true
set :git_enable_submodules, 1

set :stages, %w(staging production)
set :default_stage, 'staging'
set :use_sudo, false

role(:app) { domain }
role(:web) { domain }
role(:db, :primary => true) { domain }

namespace :deploy do
  task :link_shared_files do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/db_backups #{release_path}/db_backups"
  end

  task :update_git_submodules do
    run "cd #{release_path}; git submodule init; git submodule update"
  end

  task :submodules_and_links, :roles => [:app] do
    update_git_submodules
    link_shared_files
  end

  desc "Install the database"
  task :db_install do
     run("cd #{current_path}; /usr/bin/rake db:install RAILS_ENV=#{rails_env}")
  end
end

namespace :sample_data do
  task :reload, :roles => :app do
    run "cd #{current_path} && rake db:migrate:reset RAILS_ENV=production"
    run "cd #{current_path} && rake db:sample_data:load RAILS_ENV=production "
  end
end

after 'deploy:update_code', 'deploy:submodules_and_links'

