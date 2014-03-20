Pod::Spec.new do |s|
  s.name         = "NFMoPub"

  s.version      = "0.2.1"

  s.summary      = "NFMoPub."

  s.homepage     = "https://github.com/ninjafishstudios/NFMoPub"

	s.license      = { :type => 'FreeBSD', :file => 'LICENSE.txt' }

  s.author       = { "williamlocke" => "williamlocke@me.com" }

  s.source       = { :git => "https://github.com/ninjafishstudios/NFMoPub.git", :tag => s.version.to_s }

  s.platform     = :ios, '4.3'
  
  s.source_files =  'Classes/NFMoPub/*.[h,m]'

  s.resources = 'Resources/NFMoPub.bundle'
  
  s.frameworks = 'QuartzCore', 'CoreText'
  
  s.requires_arc = true
    
	s.dependency 'MoPubSDK', '=1.12.1'
  
end
