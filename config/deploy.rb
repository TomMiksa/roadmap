set :application, 'dmptool'
set :repo_url, 'https://github.com/DMPRoadmap/roadmap.git'

#set :user, 'dmp'

# Default branch is :master
#ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp unless ENV['BRANCH']
set :branch, ENV['BRANCH'] if ENV['BRANCH']

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/dmp/apps/roadmap'
set :share_to, 'dmp/apps/roadmap/shared'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
set :default_env, { path: "/dmp/local/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# passenger in gemfile set since we have both passenger and capistrano-passenger in gemfile
#set :passenger_in_gemfile, true

# Set whether to restart with touch of touch of tmp/restart.txt.
# There may be difficulties one way or another.  Normal restart may require sudo in some circumstances.
#set :passenger_restart_with_touch, false

namespace :deploy do
  
  after :deploy, :restart
  
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
  
  desc 'Restart Phusion'
  task :restart do
    on roles(:app), wait: 5 do
      execute "/apps/dmp/init.d/passenger-dmp.dmp restart"
    end
  end
end