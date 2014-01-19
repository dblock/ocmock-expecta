Pod::Spec.new do |s|
  s.name         = 'EXPMatchers+OCMock'
  s.version      = '1.0'
  s.summary      = 'Expecta matchers for OCMock.'
  s.description  = "Use OCMock with Expecta."
  s.homepage     = 'https://github.com/dblock/ocmock-expecta'
  s.license      = 'MIT'
  s.author       = 'Daniel Doubrovkine'
  s.source       = { :git => 'https://github.com/dblock/ocmock-expecta.git', :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'EXPMatchers+OCMockTest.{h,m}'
  s.frameworks   = 'Foundation', 'XCTest'
  s.dependencies = ['OCMock', 'Expecta']
end
