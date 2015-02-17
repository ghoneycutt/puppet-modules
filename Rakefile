task :default => :check

desc 'Check ruby syntax on all .rb files.'
task :check do
  sh 'ruby -c Puppetfile'
  sh 'ruby -c Gemfile'
  sh 'bash -n update_puppet_modules.sh'
end
