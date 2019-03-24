# CoreDataCodable

[![codecov](https://codecov.io/gh/peterringset/CoreDataCodable/branch/master/graph/badge.svg)](https://codecov.io/gh/peterringset/CoreDataCodable)
[![Build Status](https://travis-ci.org/peterringset/CoreDataCodable.svg?branch=master)](https://travis-ci.org/peterringset/CoreDataCodable)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CoreDataCodable.svg)](https://img.shields.io/cocoapods/v/CoreDataCodable.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/cocoapods/p/CoreDataCodable.svg?style=flat)

CoreDataCodable contains protocols and extensions for making Core Data play nice with Swift's `Codable` protocols

## Requirements
- iOS 10.0
- macOS 10.12 (Sierra)
- Swift 4.2

## Installation

### Cocoapods

You want to add `pod 'CoreDataCodable', '~> 1.0'` similar to the following to your Podfile:

```ruby
target 'MyApp' do
  pod 'CoreDataCodable', '~> 1.0'
end
```

Then run `pod install` inside your terminal, or from CocoaPods.app.

Alternatively to give it a test run, run the command:

```bash
$ pod try CoreDataCodable
```

### Carthage

To integrate CoreDataCodable into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "peterringset/CoreDataCodable" ~> 1.0
```

Then run `carthage update` inside your terminal.

## Usage

To make an `NSManagedObject`-subclass be parsable through `Decodable` you can declare conformance to `DecodableManagedObject`, and implement the protocol:

![Managed object model: Employee](https://raw.githubusercontent.com/peterringset/CoreDataCodable/master/Images/managed-object-data-model.png)
<!--![Managed object model class: Employee](https://raw.githubusercontent.com/peterringset/CoreDataCodable/master/managed-object-data-model.png)-->

```swift 
import CoreData
import CoreDataCodable

extension Employee: DecodableManagedObject {
    
    public enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case title
        case telephone
        case imageURL
    }

    public func setValues(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        title = try container.decode(String.self, forKey: .title)
        telephone = try container.decode(String.self, forKey: .telephone)
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
    
}
```

To use this together with Swift's `JSONDecoder`, you have to assign a managed object context instance to the decoders `userInfo`:

```swift
let decoder = JSONDecoder()
decoder.userInfo[.managedObjectContext] = persistentContainer.newBackgroundContext()
let employees = try decoder.decode(Employee.self, from: json)

```

This will insert the object into the provided context. Note that it is still up to you to save the context after parsing is done.

### Insert or update existing objects

If you have an application where you will download entities that you already have in a local database, you can use `ManagedObjectUpsert` to help you manage that. This requires the entity class to conform to `FetchableManagedObject`, a protocol that tells us how to query the local database for an existing instance.

```swift
extension Employee {
    public typealias FetchableCodingKeys = CodingKeys
    public typealias Identifier = String
    public static var identifierKey: Employee.CodingKeys {
        return .lastName
    }
}
```

Then you can modify the decoding call to be

```swift
let upsert = try decoder.decode(ManagedObjectUpsert<Employee>.self, from: json)
let employee = upsert.object
```

There is also a corresponding struct called `ManagedObjectsUpsert` for decoding an array of objects with the upsert mechanism.

### Core data codegen

`CoreDataCodable` is compatible with Core Data's codegen feature, but you should be aware that if you're using custom types (that are transformable), you will have to use the `Manual/None` alternatives. You can still get Xcode to generate the source for the entity, but you will have to regenerate the file(s) manually whenever you make changes to the object model. A good tip is to add customizations to the file named `Entity+CoreDataClass.swift`, that makes it easier whenever you need to regenerate the entity code.

```swift
import Foundation
import CoreData
import CoreDataCodable

@objc(Entity)
public class Entity: NSManagedObject {

}

extension Entity {
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }

    public func setValues(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(URL.self, forKey: .url)
    }

}
```
