//
//  ManagedObjectUpsertTests.swift
//  CoreDataCodableTests
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import XCTest

@testable import CoreDataCodable

class ManagedObjectUpsertTests: XCTestCase {

    func testInitingWithBlankDatabase() {
        let context = DataContainer().viewContext
        let json = """
        {
            "name": "lalal",
            "address": "ieieei",
            "postalCode": 11232
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        let inserted = try! decoder.decode(ManagedObjectUpsert<Person>.self, from: json).object
        XCTAssertEqual(context.insertedObjects, [inserted])
    }
    
    func testInitingWithExistingInDatabase() {
        let context = DataContainer().viewContext
        let existing = Person(context: context)
        existing.name = "lalal"
        existing.address = ""
        existing.postalCode = 0
        try! context.save()
        
        let json = """
        {
            "name": "lalal",
            "address": "ieieei",
            "postalCode": 11232
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        let updated = try! decoder.decode(ManagedObjectUpsert<Person>.self, from: json).object
        XCTAssertEqual(updated, existing)
        XCTAssertEqual(updated.address, "ieieei")
    }
    
    func testInitializingArray() {
        let context = DataContainer().viewContext
        let existing = Person(context: context)
        existing.name = "lalal"
        existing.address = ""
        existing.postalCode = 0
        try! context.save()
        
        let json = """
        [
            {
                "name": "lalal",
                "address": "ieieei",
                "postalCode": 1111
            },
            {
                "name": "lalal2",
                "address": "ieieei2",
                "postalCode": 2222
            }
        ]
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        
        XCTAssertNoThrow(try decoder.decode(ManagedObjectsUpsert<Person>.self, from: json))
        XCTAssertEqual(context.updatedObjects.count, 1)
        XCTAssertEqual((context.updatedObjects.first as? Person)?.name, "lalal")
        XCTAssertEqual(context.insertedObjects.count, 1)
        XCTAssertEqual((context.insertedObjects.first as? Person)?.name, "lalal2")
        XCTAssertNoThrow(try context.save())
    }
    
}
