Pod::Spec.new do |s|
  s.name     = 'DoActionSheetFork'
  s.version  = '1.1'
  s.author   = { 'beiliubei' => 'beiliubei@gmail.com' }
  s.homepage = 'https://github.com/beiliubei/DoActionSheet.git'
  s.summary  = 'An replacement for UIActionSheet : block-based, customizable theme, easy to use with image or map'
  s.license  = { :type => 'MIT', :file => 'License' }
  s.source   = { :git => 'https://github.com/beiliubei/DoActionSheet.git', :tag => '1.1' }
  s.source_files = 'TestActionSheet/3rdSource/UIImage-ResizeMagick/*.{h,m}','TestActionSheet/DoActionSheet/*.{h,m}'
  s.platform = :ios
  s.requires_arc = true
end
