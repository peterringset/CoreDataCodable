//
//  CodingUserInfoKey+ManagedObjectContextTests.swift
//  CoreDataCodableTests
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import XCTest

@testable import CoreDataCodable

class CodingUserInfoKey_ManagedObjectContextTests: XCTestCase {

    func testRawValue() {
        let key: CodingUserInfoKey = .managedObjectContext
        XCTAssertEqual(key.rawValue, "managedObjectContext")
    }
    
    func testMissingContext() {
        let decoder = JSONDecoder()
        
        let json = "{ \"name\": \"Name\" }".data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(TestEntity.self, from: json)) { error in
            guard case .some(.dataCorrupted(_)) = error as? DecodingError else {
                return XCTFail("Unexpected errort: \(error)")
            }
        }
    }
    
    func testContext() {
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = DataContainer().viewContext
        
        let json = "{ \"name\": \"Name\" }".data(using: .utf8)!
        XCTAssertNoThrow(try decoder.decode(TestEntity.self, from: json))
    }
    
}

private struct TestEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    let name: String
    init(from decoder: Decoder) throws {
        _ = try decoder.managedObjectContext()
        name = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .name)
    }
}
