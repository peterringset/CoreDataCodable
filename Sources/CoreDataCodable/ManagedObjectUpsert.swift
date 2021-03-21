//
//  ManagedObjectUpsert.swift
//  CoreDataCodable
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import CoreData
import Foundation

public struct ManagedObjectUpsert<Object: FetchableManagedObject & DecodableManagedObject>: Decodable where Object: NSManagedObject {
    
    public let object: Object
    
    public init(from decoder: Decoder) throws {
        if let existing = try Object.fetch(from: decoder) {
            try existing.setValues(from: decoder)
            self.object = existing
        } else {
            let container = try decoder.singleValueContainer()
            object = try container.decode(Object.self)
        }
    }
    
}

public struct ManagedObjectsUpsert<Element: FetchableManagedObject & DecodableManagedObject>: Decodable where Element: NSManagedObject {
    
    public let objects: [Element]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        objects = try container.decode([ManagedObjectUpsert<Element>].self).map({ $0.object })
    }
}
