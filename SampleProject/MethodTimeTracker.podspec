Pod::Spec.new do |s|
  s.name             = "MethodTimeTracker"
  s.version          = "1.0.0"
  s.summary          = "Librariy to measure a time spend in each method"
  s.homepage         = "https://github.com/ahimahas/MethodTimeTracker"
  s.license          = 'Restricted'
  s.author           = { "ahimahas" => "ahimahas@naver.com" }
  s.source           = { :git => "https://github.com/ahimahas/MethodTimeTracker/SampleProject", :tag => s.version }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'MSMethodTimeTracker/MSMethodTimeTracker/*'
  s.module_name = 'MethodTimeTracker'
end
