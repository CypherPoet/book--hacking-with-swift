//
//  Commit+CoreDataClass.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case commit
        case sha
        case url = "html_url"
    }
    
    enum CommitCodingKeys: String, CodingKey {
        case message
        case committer
    }
    
    enum CommitterCodingKeys: String, CodingKey {
        case date
    }
    
    
    // MARK: - Decodable
    
    public required convenience init(from decoder: Decoder) throws {
        guard
            let managedObjectContextUserInfoKey = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[managedObjectContextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Commit", in: managedObjectContext)
        else {
            fatalError("Failed to decode commit")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let commitContainer = try rootContainer.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        let committerContainer = try commitContainer.nestedContainer(keyedBy: CommitterCodingKeys.self, forKey: .committer)
        
        self.sha = try rootContainer.decode(String.self, forKey: .sha)
        self.url = try rootContainer.decode(String.self, forKey: .url)
        
        let dateString = try committerContainer.decode(String.self, forKey: .date)
        self.date = ISO8601DateFormatter().date(from: dateString) ?? Date()
        
        self.message = try commitContainer.decode(String.self, forKey: .message)
    }
}


//// MARK: - Encodable
//
//extension Commit: Encodable {
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(date, forKey: .date)
//        try container.encode(message, forKey: .message)
//        try container.encode(sha, forKey: .sha)
//        try container.encode(url, forKey: .url)
//    }
//
//}
