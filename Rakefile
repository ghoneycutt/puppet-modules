desc "Check runby syntax on all .rb files."
task :check do
   Dir['Puppetfile'].each do |path|
     sh "ruby -c #{path}"
   end
end
