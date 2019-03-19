//
//  DecodableManagedObject.swift
//  CoreDataCodable
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import CoreData
import Foundation

public protocol DecodableManagedObject: class, Decodable {
    func setValues(from decoder: Decoder) throws
}

public extension DecodableManagedObject where Self: NSManagedObject {
    
    init(from decoder: Decoder) throws {
        self.init(context: try decoder.managedObjectContext())
        try setValues(from: decoder)
    }
    
}
