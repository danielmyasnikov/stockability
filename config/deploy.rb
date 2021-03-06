# config valid only for current version of Capistrano
lock '3.4.0'

set :application, "#{fetch(:stage)}_stockability"
set :repo_url, 'https://stockability:rus9uGap@bitbucket.org/stockability-group/stockability-web.git'
set :branch, "master"


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ubuntu/apps/#{fetch(:application)}"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/unicorn.rb',
                                      'config/unicorn_init.sh')

# # Default value for linked_dirs is []
# # set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
                                               'public/assets', 'public/system', 'vendor/bundle')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  task :restart_unicorn do
    within release_path do
      execute 'sh config/unicorn_init.sh restart'
    end
  end

  after :restart, :restart_unicorn

end
