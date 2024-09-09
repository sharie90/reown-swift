require "json"

package = JSON.parse(File.read(File.join(__dir__, "Sources/WalletConnectRelay/PackageConfig.json")))

Pod::Spec.new do |spec|

  spec.name        = "reown-swift"
  spec.version     = package["version"]
  spec.summary     = "Reown WalletKit"
  spec.description = "Implementation of WalletKit"
  spec.homepage    = "https://reown.com"
  spec.license     = { :type => 'Apache-2.0', :file => 'LICENSE' }
  spec.authors          = "Reown, Inc."
  spec.source = {
    :git => 'https://github.com/reown-com/reown-swift.git',
    :tag => spec.version.to_s
  }
  
  spec.platform     = :ios, '13.0'
  spec.swift_versions = '5.3'
  spec.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-DCocoaPods'
  }

  spec.default_subspecs = 'WalletKit'

  spec.subspec 'WalletKit' do |ss|
    ss.source_files = 'Sources/WalletKit/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectSign'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectPush'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectVerify'
  end

  spec.subspec 'WalletConnectSign' do |ss|
    ss.source_files = 'Sources/WalletConnectSign/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectPairing'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectSigner'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectVerify'
    ss.dependency 'WalletConnectSwiftV2/Events'
  end

  spec.subspec 'WalletConnectVerify' do |ss|
    ss.source_files = 'Sources/WalletConnectVerify/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectUtils'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectNetworking'
  end

  spec.subspec 'WalletConnectChat' do |ss|
    ss.source_files = 'Sources/Chat/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectSync'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectIdentity'
  end

  spec.subspec 'WalletConnectSync' do |ss|
    ss.source_files = 'Sources/WalletConnectSync/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectSigner'
  end

  spec.subspec 'WalletConnectSigner' do |ss|
    ss.source_files = 'Sources/WalletConnectSigner/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectNetworking'
  end

  spec.subspec 'WalletConnectIdentity' do |ss|
    ss.source_files = 'Sources/WalletConnectIdentity/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectNetworking'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectJWT'
  end

  spec.subspec 'WalletConnectPush' do |ss|
    ss.source_files = 'Sources/WalletConnectPush/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectNetworking'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectJWT'
  end

  spec.subspec 'WalletConnectJWT' do |ss|
    ss.source_files = 'Sources/WalletConnectJWT/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectKMS'
  end

  spec.subspec 'WalletConnectNetworking' do |ss|
    ss.source_files = 'Sources/WalletConnectNetworking/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectRelay'
    ss.dependency 'WalletConnectSwiftV2/HTTPClient'
  end

  spec.subspec 'WalletConnectPairing' do |ss|
    ss.source_files = 'Sources/WalletConnectPairing/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectNetworking'
    ss.dependency 'WalletConnectSwiftV2/Events'
  end

  spec.subspec 'ReownRouter' do |ss|
    ss.source_files = 'Sources/ReownRouter/**/*.{h,m,swift}'
    ss.platform = :ios
  end

  spec.subspec 'WalletConnectRelay' do |ss|
    ss.source_files = 'Sources/WalletConnectRelay/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectJWT'
    ss.resource_bundles = {
      'WalletConnect_WalletConnectRelay' => [
         'Sources/WalletConnectRelay/PackageConfig.json'
      ]
    }
  end

  spec.subspec 'WalletConnectUtils' do |ss|
    ss.source_files = 'Sources/WalletConnectUtils/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/JSONRPC'
  end

  spec.subspec 'WalletConnectKMS' do |ss|
    ss.source_files = 'Sources/WalletConnectKMS/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectUtils'
  end

  spec.subspec 'Commons' do |ss|
    ss.source_files = 'Sources/Commons/**/*.{h,m,swift}'
  end

  spec.subspec 'Events' do |ss|
    ss.source_files = 'Sources/Events/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectNetworking'
    ss.dependency 'WalletConnectSwiftV2/WalletConnectUtils'
  end

  spec.subspec 'JSONRPC' do |ss|
    ss.source_files = 'Sources/JSONRPC/**/*.{h,m,swift}'
    ss.dependency 'WalletConnectSwiftV2/Commons'
  end
  
  spec.subspec 'HTTPClient' do |ss|
    ss.source_files = 'Sources/HTTPClient/**/*.{h,m,swift}'
  end

end
