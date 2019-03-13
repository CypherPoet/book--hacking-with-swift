//
//  Commit+CoreDataProperties.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//
//

import Foundation
import CoreData


extension Commit {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }
    
    // MARK: - Attributes
    
    @NSManaged public var date: Date
    @NSManaged public var message: String
    @NSManaged public var sha: String
    @NSManaged public var url: String

    
    // MARK: - Relationships
    
    @NSManaged public var author: Author
}



// MARK: - Fetch Helpers

extension Commit {
    enum Predicate {
        static let bugFix = NSPredicate(format: "message CONTAINS[c] 'fix'")
        static let notPR = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
        static let last24Hours = NSPredicate(format: "date > %@", Date().addingTimeInterval(-86_400) as NSDate)
        static let durianCommits = NSPredicate(format: "author.name == 'Joe Groff'")
        static let allCommits: NSPredicate? = nil
    }
    
    enum SortDescriptor {
        static let dateDesc = NSSortDescriptor(key: "date", ascending: false)
        static let messageAsc = NSSortDescriptor(key: "message", ascending: true)
        static let authorNameAsc = NSSortDescriptor(key: "author.name", ascending: true)
    }
    
    static var dateSortedFetchRequest: NSFetchRequest<Commit> {
        let request = createFetchRequest()
        
        request.sortDescriptors = [SortDescriptor.dateDesc, SortDescriptor.messageAsc]
        return request
    }
    
    static var newestCommitRequest: NSFetchRequest<Commit> {
        let request = createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sort]
        request.fetchLimit = 1
        
        return request
    }
}


// MARK: - Computed properties

extension Commit {
    static func newestCommitDate(in context: NSManagedObjectContext) -> Date {
        let request = newestCommitRequest
        
        if let commits = try? context.fetch(request) {
            if !commits.isEmpty {
                return commits[0].date.addingTimeInterval(1)
            }
        }
        
        return Date(timeIntervalSince1970: 0)
    }
}
