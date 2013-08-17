Gem::Specification.new do |specs|
  specs.name        = 'illusionist'
  specs.version     = '0.0.2'
  specs.date        = '2013-08-17'
  specs.summary     = "Rack app image server."
  specs.description = "Resizes images on the fly and caches the restults."
  specs.authors     = ["Daniel H. Green"]
  specs.email       = 'linuxdan@gmail.com'
  specs.files       = ["bin/illusionist", "lib/illusionist.rb"]
  specs.homepage    = 'https://github.com/radfahrer/illusionist'
  specs.add_dependency('rack')
  specs.add_dependency('rmagick')
  specs.executables << 'illusionist'
end