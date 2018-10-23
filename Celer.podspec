Pod::Spec.new do |s|
  s.name         = "Celer"
  s.version      = "0.0.1"
  s.summary      = "SDK for celer clients"
  s.description  = <<-DESC
                    This is used for integrate DApps with celer support.
                   DESC
  s.homepage     = "https://www.celer.network/"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Jinyao Li" => "jinyao@celer.network" }
  s.social_media_url   = "https://twitter.com/celernetwork?lang=en"
  s.platform           = :ios, "9.0"
  s.source            = { :git => "https://github.com/celer-network/CelerPod.git", :tag => "#{s.version}" }
  s.source_files  = "Celer", "Celer/**/*.{h,m,swift}"
  s.exclude_files = "Celer/Exclude"
  s.public_header_files = "Celer"
  s.vendored_frameworks = "Frameworks/Celersdk.framework"
  s.swift_version = "4.0"
  s.xcconfig = { 'VALID_ARCHS' =>  'arm64' }
  s.requires_arc = true
end
