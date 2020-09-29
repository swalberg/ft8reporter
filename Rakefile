require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:sequel)
PadrinoTasks.init

desc 'Deploy the app'
task :deploy do
  system "rsync -avz --exclude=.git --exclude=db/*.db  . -e 'ssh -p 9099' ft8@ertw.com:ft8reporter/"
  system "ssh -p 9099 ft8@ertw.com 'sudo /usr/bin/systemctl restart ft8'"
end
