task :default => :check

desc 'Check syntax'
task :check do
  sh 'ruby -c Puppetfile'
  sh 'ruby -c Gemfile'

  puts "\n=== Validating shell (*.sh) files"
  Dir['**/*.sh'].each do |sh|
    sh "bash -n #{sh}" unless sh =~ /^modules\//
  end
end

desc 'Check that modules exist'
task :check_exists do
  sh 'scripts/check_modules_exist.sh'
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
