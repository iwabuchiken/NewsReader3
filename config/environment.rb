# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
NewsReader3::Application.initialize!


#debug
# => REF http://stackoverflow.com/questions/9852216/reload-lib-files-without-restart-dev-server-in-rails-3-1 answered Apr 10 '12 at 21:54
# config.autoload_paths += Dir["#{config.root}/lib/**/"]


# => REF http://stackoverflow.com/questions/1114388/rails-reloading-lib-files-without-having-to-restart-server answered Jul 11 '09 at 18:54
# config.load_paths += %W( #{RAILS_ROOT}/lib )