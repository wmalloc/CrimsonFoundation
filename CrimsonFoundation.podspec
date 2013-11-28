Pod::Spec.new do |s|
  s.name     = 'CrimsonFoundation'
  s.version  = '1.0.0'
  s.license  = 'Commercial'
  s.summary  = 'CrimsonFoundation'
  s.homepage = 'http://www.crimsonresearch.net'
  s.author   = { 'Crimson Research, Inc.' => 'http://www.crimsonresearch.net' }
  s.source   = { :git => 'ssh://git.crimsonresearch.net/Users/Repos/CrimsonFoundation.git', :tag => '${version}' }
  s.description = 'CrimsonFoundation'
  s.platform = :ios, "7.0"
  s.platform = :osx, "10.8"
  s.source_files = 'CrimsonFoundation/**/*.{h,m}'
  s.public_header_files = 'CrimsonFoundation/**/*.h'
  s.framework = 'SystemConfiguration'
  s.requires_arc = true
  s.prefix_header_file = 'CrimsonFoundation/CrimsonFoundation.h'
  s.dependency 'CocoaLumberjack', '1.6.2'
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.8"
end
