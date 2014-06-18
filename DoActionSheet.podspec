Pod::Spec.new do |s|
  s.name     = 'DoActionSheet'
  s.version  = '1.0'
  s.author   = { 'JackShi' => 'shiguifei@gmail.com' }
  s.homepage = 'https://github.com/donobono/DoActionSheet'
  s.summary  = 'An replacement for UIActionSheet : block-based, customizable theme, easy to use with image or map'
  s.license  = { :type => 'MIT', :file => 'License' }
  s.source   = { :git => 'https://github.com/donobono/DoActionSheet.git', :tag => '1.0' }
  s.source_files = 'TestActionSheet/3rdSource/UIImage-ResizeMagick/*.{h,m}','TestActionSheet/DoActionSheet/*.{h,m}'
  s.platform = :ios
  s.requires_arc = true
end
