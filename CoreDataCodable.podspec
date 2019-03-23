Pod::Spec.new do |spec|
  spec.name         = "CoreDataCodable"
  spec.version      = "0.0.1"
  spec.summary      = "Make NSManagedObject and Core Data interoperate with Swift's Decodable"

  spec.description  = <<-DESC
                   CoreDataCodable contains protocols, extensions and types for making Core Data and NSManagedOject interoperate nicely with Swift's Decodable protocol.
                   DESC

  spec.homepage     = "https://github.com/peterringset/CoreDataCodable"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Peter Ringset" => "peter@ringset.no" }

  spec.ios.deployment_target = "10.0"
  spec.macos.deployment_target = "10.12"
  spec.swift_version = "4.2"

  spec.source       = { :git => "https://github.com/peterringset/CoreDataCodable.git", :tag => "#{spec.version}" }
  spec.source_files  = "CoreDataCodable/**/*.{h,m,swift}"

  spec.public_header_files = "CoreDataCodable/**/*.h"
end
