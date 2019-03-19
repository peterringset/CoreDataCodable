//
//  PersistentContainer.swift
//  CoreDataCodableTests
//
//  Created by Peter Ringset on 19/03/2019.
//  Copyright © 2019 Ringset. All rights reserved.
//

import CoreData

class DataContainer: NSPersistentContainer {
    
    lazy var fileManager: FileManager = .default
    
    convenience init() {
        self.init(name: "Model")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentStoreDescriptions = [description]
        
        loadPersistentStores { (description, error) in }
    }
    
}
