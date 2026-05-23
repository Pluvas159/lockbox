Pod::Spec.new do |s|
  s.name             = 'Lockbox'
  s.version          = '1.0.0'
  s.summary          = 'Lockbox Native iOS SDK.'
  s.description      = 'The core native iOS library containing Keychain secure storage.'
  s.homepage         = 'github.com'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Developer' => '' }
  s.source           = { :path => '.' }
  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'Lockbox/**/*.swift'
end
