

Pod::Spec.new do |s|
  s.name = 'GameObjects'
  s.version = '0.0.1'
  s.license = 'WTFPL'
  s.summary = 'Objects for games'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }

  s.platform = :osx, '10.10'
  s.source_files = 'Classes/*.swift'


  s.dependency 'LlamaKit'

  s.dependency 'SwiftConfig'
  s.dependency 'SwiftLogger'
  s.dependency 'SwiftDataStructures'
  s.dependency 'BrynSwift'

  s.frameworks = ['SpriteKit', 'LlamaKit']

  # s.homepage = 'https://github.com/Alamofire/Alamofire'
  # s.social_media_url = 'http://twitter.com/mattt'
  # s.source = { :git => 'https://github.com/brynbellomy/GameObjects.git', :tag => '0.0.1' }
end
