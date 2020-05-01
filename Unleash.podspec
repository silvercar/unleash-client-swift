Pod::Spec.new do |s|
  s.name = 'Unleash'
  s.version = '1.0.6'
  s.license = 'MIT'
  s.summary = 'Feature Flagging for Swift'
  s.homepage = 'https://github.com/silvercar/unleash-client-swift'
  s.authors = { 'Silvercar Inc.' => 'mobiledevelopers@silvercar.com' }
  s.source = { :git => 'https://github.com/silvercar/unleash-client-swift.git', :tag => s.version }
  s.documentation_url = 'https://github.com/silvercar/unleash-client-swift/blob/master/README.md'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target     = '10.12'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target    = '10.0'

  s.swift_versions = ['4.2', '5.0', '5.1', '5.2']

  s.source_files = 'Unleash/**/*.{swift}'

  s.dependency 'PromiseKit', '~> 6.10'
end
