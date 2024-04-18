Pod::Spec.new do |s|
  s.name             = '{{ libName }}'
  s.version          = '1.0.0'
  s.summary          = 'Summary'

  s.description      = 'Description'

  s.homepage         = 'https://github.com/{{ githubUser }}/{{ libName }}'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '{{ githubUser }}' => 'your@email.com' }
  s.source           = { :git => 'https://github.com/{{ githubUser }}/{{ libName }}.git',
                         :tag => s.version.to_s
                       }
  s.social_media_url = ''
  
  s.ios.deployment_target = '13'

  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit'
  s.swift_version = '5.7'
end
