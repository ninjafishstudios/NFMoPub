Pod::Spec.new do |s|
  s.name         = "NFAdMob"

  s.version      = "0.2.1"

  s.summary      = "NFAdMob."

  s.homepage     = "https://github.com/ninjafishstudios/NFAdMob"

	s.license      = { :type => 'FreeBSD', :file => 'LICENSE.txt' }

  s.author       = { "williamlocke" => "williamlocke@me.com" }

  s.source       = { :git => "https://github.com/ninjafishstudios/NFAdMob.git", :tag => s.version.to_s }

  s.platform     = :ios, '4.3'
  
  s.source_files =  'Classes/NFAdMob/*.[h,m]'

  s.resources = 'Resources/NFAdMob.bundle'
  
  s.frameworks = 'QuartzCore', 'CoreText'
  
  s.requires_arc = true
    
	s.dependency 'Google-AdMob-Ads-SDK'
  
end
