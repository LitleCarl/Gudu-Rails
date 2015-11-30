# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'zaocan84'
set :repo_url, 'git@github.com:LitleCarl/Gudu-Rails.git'

# 重启Passenger
set :passenger_restart_with_touch, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, '/github/zaocan84'

# Default value for :scm is :git
 set :scm, :git

set :branch, 'release/production'
# Default value for :format is :pretty
 set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false
 set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :linked_files, %w{config/database.yml Gemfile.lock}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


before 'deploy:check:linked_files', 'deploy:shared:execute' do
  on roles(:all) do
    work_dir = "/github/#{fetch(:application)}"

    project_dir = "#{work_dir}/#{fetch(:branch)}"

    if test("[ -d #{project_dir} ]")

    else
      execute "source ~/.bashrc; mkdir -p #{work_dir}; cd #{work_dir}; git clone #{repo_url} #{fetch(:branch)}; cd #{project_dir}; gem install bundler; git checkout -t -b #{fetch(:branch)} origin/#{fetch(:branch)}"
    end

    execute "cd #{shared_path}; touch .rufus-scheduler.lock"

    bundle = ENV['bundle']

    puts "bundle = #{bundle}"

    execute "source ~/.bashrc; cd #{project_dir}; git pull;"

    if bundle.eql?('update')
      execute "source ~/.bashrc; cd #{project_dir}; bundle update; bundle package --all;"
    end

    execute "cp #{project_dir}/Gemfile.lock #{shared_path}"
    #execute "mkdir -p #{shared_path}/bundle/ruby/#{ruby_version}/cache; cp -r #{project_dir}/vendor/cache/* #{shared_path}/bundle/ruby/#{ruby_version}/cache"

    execute "cp -r #{project_dir}/config/* #{shared_path}/config"

    #execute "rm -fr #{shared_path}/config/puma; cp -r #{project_dir}/config/puma #{shared_path}/config"
  end
end

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
      work_dir = "/github/#{fetch(:application)}/current"

      execute "cd #{work_dir};rake tmp:cache:clear; rm -rf ./tmp ; mkdir tmp ; chmod 777 -R ./tmp "

      nginx_dir = '/opt/nginx/sbin'

      #execute "cd #{nginx_dir};./nginx -s stop; ./nginx "

    end
  end
end

