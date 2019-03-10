//
//  CodingUserInfoKey+Util.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//
// (Kudos to Andrea Prearo: https://github.com/andrea-prearo/SwiftExamples/blob/master/CoreDataCodable/CoreDataCodable/Extensions/CodingUserInfoKey%2BUtil.swift)
//

import Foundation

public extension CodingUserInfoKey {
    /// Helper property to retrieve the Core Data managed object context from the `userInfo` dictionary
    /// of a decoder instance
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
