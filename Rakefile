task :default => :check

desc 'Check syntax'
task :check do
  sh 'ruby -c Puppetfile'
  sh 'ruby -c Gemfile'
  sh 'bash -n update_puppet_modules.sh'
end

desc 'Install pre-commit hook'
task :precommit do
  sh 'install -C -m 0755 hooks/pre-commit .git/hooks/pre-commit'
end

desc 'Install modules'
task :install do
  sh 'rm -fr modules modules.tmp; rake check && librarian-puppet install --verbose --path=modules.tmp && mv modules.tmp modules'
end

desc 'Clean modules'
task :clean do
  sh 'rm -fr modules modules.tmp'
end
