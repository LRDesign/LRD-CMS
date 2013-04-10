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

  task :make_tmp_writable do
    run "chgrp web #{release_path}/tmp"
    run "mkdir #{release_path}/tmp/cache"
    run "chgrp -R web #{release_path}/tmp/cache"
    run "chmod -R go+rw #{release_path}/tmp/cache"
  end

  task :make_sitemap_writable do
    file = "#{release_path}/public/sitemap.xml"
    run "touch #{file}"
    run "chgrp web #{file}"
    run "chmod g+rw #{file}"
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

after 'deploy:update_code', 'deploy:link_shared_files', 'deploy:make_tmp_writable', 'deploy:make_sitemap_writable'

