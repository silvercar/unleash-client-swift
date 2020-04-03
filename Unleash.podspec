Pod::Spec.new do |s|
  s.name = 'Unleash'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Feature Flagging for Swift'
  s.homepage = 'https://github.com/silvercar/unleash-client-swift'
  s.authors = { 'Silvercar Inc.' => 'mobiledevelopers@silvercar.com' }
  s.source = { :git => 'https://github.com/silvercar/unleash-client-swift.git', :tag => s.version }
  s.documentation_url = 'https://github.com/silvercar/unleash-client-swift/blob/master/README.md'

  s.ios.deployment_target = '10.0'

  s.swift_versions = ['4.2', '5.0', '5.1']

  s.source_files = 'unleash/**/*.swift'

  s.dependency 'PromiseKit', '~> 6.11'
  s.dependency 'PromiseKit/Foundation', '~> 6.0'
end
