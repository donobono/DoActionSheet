Pod::Spec.new do |s|
  s.name     = 'DoActionSheet'
  s.version  = '0.0.1'
  s.author   = { 'JackShi' => 'shiguifei@gmail.com' }
  s.homepage = 'https://github.com/donobono/DoActionSheet'
  s.summary  = 'An replacement for UIActionSheet : block-based, customizable theme, easy to use with image or map'
  s.license  = { :type => 'MIT', :file => 'License' }
  s.source   = { :git => 'https://github.com/donobono/DoActionSheet.git', :commit => 'b06379deee64555c77fd12ef09d5af8bc7d0575e' }
  s.source_files = 'TestActionSheet/3rdSource/UIImage-ResizeMagick/*.{h,m}','TestActionSheet/DoActionSheet/*.{h,m}'
  s.platform = :ios
  s.requires_arc = true
end
