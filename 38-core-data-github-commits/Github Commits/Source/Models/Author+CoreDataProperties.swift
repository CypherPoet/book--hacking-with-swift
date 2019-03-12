//
//  Author+CoreDataProperties.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var commits: NSSet

}

// MARK: Generated accessors for commits
extension Author {

    @objc(addCommitsObject:)
    @NSManaged public func addToCommits(_ value: Commit)

    @objc(removeCommitsObject:)
    @NSManaged public func removeFromCommits(_ value: Commit)

    @objc(addCommits:)
    @NSManaged public func addToCommits(_ values: NSSet)

    @objc(removeCommits:)
    @NSManaged public func removeFromCommits(_ values: NSSet)

}


// MARK: - Fetch Request Helpers

extension Author {
    static var defaultSortDescriptors: [NSSortDescriptor] = [
        NSSortDescriptor(key: "name", ascending: false)
    ]

    
    static var sortedFetchRequest: NSFetchRequest<Author> {
        let request = createFetchRequest()
        request.sortDescriptors = defaultSortDescriptors

        return request
    }
    
    static func sortedFetchBy(name: String) -> NSFetchRequest<Author> {
        let request = sortedFetchRequest
        
        request.predicate = NSPredicate(format: "name == %@", name)

        return request
    }
}
