


Pod::Spec.new do |s|

s.name         = "FQ_AlertView"

s.version      = "0.0.1"

s.summary      = "A short description of FQ_AlertView."

s.homepage              = 'https://github.com/FQDEVER/FQ_AlertView'

s.license                    = { :type => 'MIT',:file => 'LICENSE' }

s.author                    = { 'FQDEVER' => '814383466@qq.com' }

s.source                    = { :git => 'https://github.com/FQDEVER/FQ_AlertView.git',:tag => s.version }

s.source_files              = 'FQ_AlertView/*.{h,m}'

s.platform                  = :ios

s.ios.deployment_target      = '8.0'

s.dependency                'Masonry'

end