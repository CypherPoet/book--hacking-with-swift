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
    
    enum RootCodingKeys: String, CodingKey {
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
        case name
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
        
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let commitContainer = try rootContainer.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        let committerContainer = try commitContainer.nestedContainer(keyedBy: CommitterCodingKeys.self, forKey: .committer)
        
        self.sha = try rootContainer.decode(String.self, forKey: .sha)
        self.url = try rootContainer.decode(String.self, forKey: .url)
        
        let dateString = try committerContainer.decode(String.self, forKey: .date)
        self.date = ISO8601DateFormatter().date(from: dateString) ?? Date()
        
        self.message = try commitContainer.decode(String.self, forKey: .message)

        let authorName = try committerContainer.decode(String.self, forKey: .name)
        self.author = try fetchAuthor(named: authorName, in: managedObjectContext, with: decoder)
    }
}

extension Commit {
    func fetchAuthor(
        named authorName: String,
        in context: NSManagedObjectContext,
        with decoder: Decoder
    ) throws -> Author {
        if let authors = try? context.fetch(Author.sortedFetchBy(name: authorName)) {
            if !authors.isEmpty {
                return authors.first!
            }
        }
        
        let author = try Author(from: decoder)
        return author
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
