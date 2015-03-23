Pod::Spec.new do |s|
  s.name         = 'Expecta+OCMock'
  s.version      = '1.1.0'
  s.summary      = 'Expecta matchers for OCMock 2.0.'
  s.description  = "Extends Expecta with matchers for OCMock, making it easy to check a method is called, its arguments and the return values for a function in one line of code."
  s.homepage     = 'https://github.com/dblock/ocmock-expecta'
  s.license      = 'MIT'
  s.author       = ['Orta Therox' => "orta.therox@gmail.com", 'Daniel Doubrovkine' => "dblock@dblock.org"]
  s.source       = { :git => 'https://github.com/dblock/ocmock-expecta.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Expecta+OCMock.{h,m}'
  s.frameworks   = 'Foundation', 'XCTest'
  s.dependency 'Expecta'
  s.dependency 'OCMock', '~> 2.2.2'
end
