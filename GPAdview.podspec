Pod::Spec.new do |s|
s.name = 'GPAdview'
s.version = '0.1.0'
s.license = 'MIT'
s.summary = 'an easy way to build ad for app launch'
s.homepage = 'https://github.com/GeekSprite/GPAdview'
s.authors = { '刘小杰' => 'a1019448557@gmail.com' }
s.source = { :git => 'https://github.com/GeekSprite/GPAdview.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'GPAdview/*.{h,m,swift}'
s.resources = 'GPAdview/*.{png,xib}'
end
