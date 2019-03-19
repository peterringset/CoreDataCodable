//
//  DecodableManagedObjectTests.swift
//  CoreDataCodableTests
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import XCTest
@testable import CoreDataCodable

class DecodableManagedObjectTests: XCTestCase {

    func testDecodingFromJSON_success() {
        let context = DataContainer().viewContext
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        
        let json = """
        {
            "name": "Testing",
            "address": "Address 123",
            "postalCode": 4455
        }
        """.data(using: .utf8)!
        
        XCTAssertNoThrow(try decoder.decode(Person.self, from: json))
        XCTAssertEqual(context.insertedObjects.count, 1)
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(context.insertedObjects.count, 0)
    }
    
}

extension Person: DecodableManagedObject {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case name
        case postalCode
    }
    
    public func setValues(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        name = try container.decode(String.self, forKey: .name)
        postalCode = try container.decode(Int16.self, forKey: .postalCode)
    }
    
}
