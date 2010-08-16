require File.expand_path("../lib/gem_init/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.name              = "gem_init"
  s.rubyforge_project = "[none]"
  s.version           = GemInit::Version::STRING
  s.authors           = "Norman Clarke"
  s.email             = "norman@njclarke.com"
  s.homepage          = "http://github.com/norman/gem_init"
  s.summary           = "My new gem boilerplate."
  s.description       = "This is the code I use to set up a new Ruby Gem."
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = true
  s.test_files        = Dir.glob "test/**/*_test.rb"
  s.files             = `git ls-files`.split("\n").reject {|f| f =~ /^\./}
  s.executables       = ["gem_init"]
end
