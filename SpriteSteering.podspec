Pod::Spec.new do |s|
  s.name = 'SpriteSteering'
  s.version = '0.0.1'
  s.license = 'WTFPL'
  s.summary = 'Node steering and movement classes (works with SpriteKit + anything else)'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/SpriteSteering'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Classes/*.swift'
  s.requires_arc = true

  s.dependency 'Funky'
  s.dependency 'Signals'
  s.dependency 'BrynSwift'
  s.dependency 'GameObjects'

  s.source = { :git => 'https://github.com/brynbellomy/SpriteSteering.git', :tag => s.version }
end
