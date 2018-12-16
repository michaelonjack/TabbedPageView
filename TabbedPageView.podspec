Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "TabbedPageView"
s.summary = "TabbedPageView allows a user to quickly create a UIView containing multiple controller views with navigation tabs."
s.requires_arc = true

# 2
s.version = "0.0.14"

# 3
s.license = { :type => "MIT" }

# 4 - Replace with your name and e-mail address
s.author = { "Michael Onjack" => "mikeonjack@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/michaelonjack/TabbedPageView"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/michaelonjack/TabbedPageView.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "TabbedPageView/*.{swift}"

# 9
#s.resources = "TabbedPageView/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
