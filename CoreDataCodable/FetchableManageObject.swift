//
//  FetchableManageObject.swift
//  CoreDataCodable
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import CoreData
import Foundation

public protocol FetchableManagedObject {
    
    associatedtype FetchableCodingKeys: CodingKey
    associatedtype Identifier: Decodable & CVarArg
    static var identifierKey: FetchableCodingKeys { get }
    
}

extension FetchableManagedObject where Self: NSManagedObject {
    
    static func fetch(from decoder: Decoder) throws -> Self? {
        let context = try decoder.managedObjectContext()
        let container = try decoder.container(keyedBy: FetchableCodingKeys.self)
        let identifier = try container.decode(Identifier.self, forKey: identifierKey)
        let request = NSFetchRequest<Self>(entityName: String(describing: Self.self))
        request.predicate = NSPredicate(format: "\(identifierKey.stringValue) = %@", identifier)
        return try context.fetch(request).first
    }
    
}
