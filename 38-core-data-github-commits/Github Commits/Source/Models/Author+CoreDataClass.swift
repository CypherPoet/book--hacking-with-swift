//
//  Author+CoreDataClass.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Author)
public class Author: NSManagedObject, Decodable {
    
    enum RootCodingKeys: String, CodingKey {
        case commit
    }
    
    enum CommitCodingKeys: String, CodingKey {
        case committer
    }
    
    enum CommitterCodingKeys: String, CodingKey {
        case name
        case email
    }
    
    
    // MARK: - Decodable
    
    public required convenience init(from decoder: Decoder) throws {
        guard
            let managedObjectContextUserInfoKey = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[managedObjectContextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Author", in: managedObjectContext)
            else {
                fatalError("Failed to decode author")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let commitContainer = try rootContainer.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        let committerContainer = try commitContainer.nestedContainer(keyedBy: CommitterCodingKeys.self, forKey: .committer)
        
        self.email = try committerContainer.decode(String.self, forKey: .email)
        self.name = try committerContainer.decode(String.self, forKey: .name)
    }
}
