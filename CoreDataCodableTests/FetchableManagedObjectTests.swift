//
//  FetchableManagedObjectTests.swift
//  CoreDataCodableTests
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import CoreData
import XCTest

@testable import CoreDataCodable

class FetchableManagedObjectTests: XCTestCase {

    func testFetch() {
        let context = DataContainer().viewContext
        let countRequest = NSFetchRequest<Person>(entityName: "Person")

        XCTAssertEqual(try! context.count(for: countRequest), 0)

        let person1 = Person(context: context)
        person1.name = "123"
        person1.address = "654"
        person1.postalCode = 987
        
        let person2 = Person(context: context)
        person2.name = "234"
        person2.address = "765"
        person2.postalCode = 876
        
        try! context.save()
        
        XCTAssertEqual(try! context.count(for: countRequest), 2)

        let json = """
        { "name": "123" }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context

        let fetchedPerson = try! decoder.decode(Wrapper.self, from: json).value
        XCTAssertEqual(try! context.count(for: countRequest), 2)
        XCTAssertEqual(person1.objectID, fetchedPerson?.objectID)
    }
    
}

extension Person: FetchableManagedObject {
    public typealias FetchableCodingKeys = Person.CodingKeys
    public typealias Identifier = String
    public static var identifierKey: Person.CodingKeys {
        return FetchableCodingKeys.name
    }
}

private struct Wrapper: Decodable {
    let value: Person?
    init(from decoder: Decoder) throws {
        value = try Person.fetch(from: decoder)
    }
}
