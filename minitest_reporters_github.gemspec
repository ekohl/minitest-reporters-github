Gem::Specification.new do |s|
  s.name        = 'minitest_reporters_github'
  s.version     = '1.0.0'
  s.authors     = ['Ewoud Kohl van Wijngaarden', 'Earlopain']
  s.homepage    = 'https://github.com/ekohl/minitest_reporters_github'
  s.summary     = 'The GitHub Actions reporter for minitest-reporters'
  s.description = 'A separate gem until https://github.com/minitest-reporters/minitest-reporters/pull/332 is merged'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7', '< 4'

  # Pinned to a minor version because the feature may be added in a minor
  # https://github.com/minitest-reporters/minitest-reporters/pull/332
  s.add_dependency 'minitest-reporters', '~> 1.6.0'

  s.add_development_dependency 'rake', '~> 13.0'

  s.files         = `git ls-files lib test Rakefile`.split("\n")
end
