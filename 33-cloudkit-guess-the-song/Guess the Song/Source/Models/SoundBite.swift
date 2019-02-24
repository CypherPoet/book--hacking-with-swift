//
//  SoundBite.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CloudKit


class SoundBite: NSObject {
    var recordID: CKRecord.ID
    var genre: String
    var comments: String
    var audio: URL!
    
    init(record: CKRecord) {
        self.recordID = record.recordID
        self.genre = record["genre"] ?? ""
        self.comments = record["comments"] ?? ""
    }
}
