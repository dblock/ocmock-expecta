Pod::Spec.new do |s|
  s.name         = 'Expecta+OCMock'
  s.version      = '1.0.0'
  s.summary      = 'Expecta matchers for OCMock 2.0.'
  s.description  = "Use OCMock with Expecta."
  s.homepage     = 'https://github.com/dblock/ocmock-expecta'
  s.license      = 'MIT'
  s.author       = ['Orta Therox' => "orta.therox@gmail.com", 'Daniel Doubrovkine' => "dblock@dblock.org"]
  s.source       = { :git => 'https://github.com/dblock/ocmock-expecta.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Expecta+OCMock.{h,m}'
  s.frameworks   = 'Foundation', 'XCTest'
  s.dependencies = ['OCMock', 'Expecta']
end
