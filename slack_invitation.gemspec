$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'slack_invitation/version'

Gem::Specification.new do |spec|
  # Project
  spec.name        = 'slack_invitation'
  spec.version     = SlackInvitation::VERSION
  spec.licenses    = ['MIT']
  spec.platform    = Gem::Platform::RUBY
  spec.homepage    = 'http://slack-invitation.nacyot.com'
  spec.summary     = 'Slack invitation automation using selenium'
  spec.description = 'Slack invitation automation using selenium'

  # Requirement
  spec.required_ruby_version = '>= 2.0.0'
  
  # Author
  spec.authors     = ['Daekwon Kim']
  spec.email       = ['propellerheaven@gmail.com']

  # Files
  all_files = `git ls-files -z`.split("\x0")
  spec.files = all_files.grep(%r{^(bin|lib)/})
  spec.executables = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  
  # Dependency
  spec.add_dependency('selenium-webdriver', '~>2')
end
