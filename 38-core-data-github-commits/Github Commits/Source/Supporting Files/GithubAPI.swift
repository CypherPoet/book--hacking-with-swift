//
//  GithubAPI.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum GithubAPI {
    static let baseURL = "https://api.github.com"
    static let commits = "\(GithubAPI.baseURL)/repos/apple/swift/commits"
    
    enum QueryParams {
        static let perPage = "per_page"
        static let sinceDate = "since"
    }
}
