Pod::Spec.new do |s|
s.name         = 'yimrefresh'
s.version      = '0.0.6'
s.summary      = 'A Refresh Control Like Android'
s.homepage     = 'https://github.com/yiiim/yimediter'
s.license      = 'MIT'
s.authors      = {'ybz' => 'ybz975218925@live.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/yiiim/yimrefresh.git', :tag => s.version}
s.source_files = 'yimrefresh/yimrefresh/yimrefresh/**/*.{h,m,c}','yimediter/*.{h,m}'
s.resource     = 'yimrefresh/yimrefresh/yimrefresh/*.bundle'
s.requires_arc = true
end
