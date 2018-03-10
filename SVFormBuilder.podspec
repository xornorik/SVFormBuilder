Pod::Spec.new do |s|

  s.name         = "SVFormBuilder"
  s.version      = "0.0.1"
  s.summary      = "A short description of SVFormBuilder..."

# 2
s.version = "0.0.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4
s.author = { "Srinivas Vemuri" => "srinivas@mobcast.in" }

# 5
s.homepage = "https://github.com/xornorik/SVFormBuilder"

# 6
s.source = { :git => "https://github.com/xornorik/SVFormBuilder.git", :tag => "#{s.version}"}

# 7
s.framework = "UIKit"

# 8
s.source_files = "SVFormBuilder/**/*.{swift}"

# 9
s.resources = "SVFormBuilder/**/*.{png,jpeg,jpg,storyboard,xib,xcassets`}"

end
