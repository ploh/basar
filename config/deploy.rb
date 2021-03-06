# configured according to https://www.phusionpassenger.com/library/deploy/apache/automating_app_updates/ruby/

# config valid only for current version of Capistrano
# lock '3.4.0'

set :application, 'basar'
set :repo_url, 'git@github.com:ploh/basar.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/vhosts/kids-basar.de/app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('db/production.sqlite3',
                                                 #'db/production.sqlite3-shm',
                                                 #'db/production.sqlite3-wal', @@@ why does this get corrupt???
                                                 'config/log_level')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'vendor/bundle',
                                               'public/system',
                                               'public/uploads',
                                               'public/stop')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 40

set :rbenv_type, :system
set :rbenv_ruby, '2.3.1'

set :bundle_path, nil
set :bundle_flags, "--quiet --system"

set :passenger_restart_with_touch, true

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
