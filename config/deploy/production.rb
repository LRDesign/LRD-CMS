set :user, 'lrd'
set :domain, 'lrd-cms.lrdesign.com'
set :applicationdir, "/home/#{user}/#{domain}"
set :deploy_to, applicationdir
set :keep_releases, 10                
set :branch, 'master'         

set :rails_env, "production"        
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

