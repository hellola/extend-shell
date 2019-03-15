# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','extend-shell','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'extend-shell'
  s.version = ExtendShell::VERSION
  s.author = 'Ewoudt Kellerman'
  s.email = 'ewoudtk@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'An awesome shell backend extension, tailored for zsh'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','extend-shell.rdoc']
  s.rdoc_options << '--title' << 'extend-shell' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables = ['extend-shell', 'extend-keys']
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.16.1')
end
