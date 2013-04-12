default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Overwrite the default deploy start/stop/restart actions with passenger ones
$:.push '.'
require 'lib/capistrano/remote_sync'
require 'lib/capistrano/passenger'
require 'capistrano/ext/multistage'
require 'bundler'
require 'bundler/capistrano'
set :bundle_without,  [:development, :test]

set :repository,  "git@github.com:LRDesign/LRD-CMS.git"
#set :deploy_via, :remote_cache
set :scm, 'git'
set :scm_verbose, true

set :stages, %w(staging production)
set :default_stage, 'staging'
set :use_sudo, false

set :user,   'root'
set :runner, 'apache'
set :group,  'apache'

role(:app) { domain }
role(:web) { domain }
role(:db, :primary => true) { domain }

namespace :deploy do
  task :link_shared_files do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/db_backups #{release_path}/db_backups"
  end

  task :make_tmp_writable do
    run "chown #{runner}:#{group} #{release_path}/tmp"
    run "mkdir #{release_path}/tmp/cache"
    run "chown -R #{runner}:#{group} #{release_path}/tmp/cache"
    run "chmod -R g+rw #{release_path}/tmp"
  end

  task :make_sitemap_writable do
    file = "#{release_path}/public/sitemap.xml"
    run "touch #{file}"
    run "chown #{runner}:#{group} #{file}"
    run "chmod g+rw #{file}"
  end

  after "deploy:setup", :setup_group
  task :setup_group do
    run "chown -R #{runner}:#{group} #{deploy_to} && chmod -R g+s #{deploy_to}"
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

# use this if assets precompile is on in capfile
before "deploy:assets:precompile",'deploy:make_tmp_writable', 'deploy:make_sitemap_writable',  "deploy:link_shared_files"

# use this if assets precompile is OFF in capfile
#after "deploy:update_code", "deploy:link_shared_files",
#"deploy:make_sitemap_writable"
