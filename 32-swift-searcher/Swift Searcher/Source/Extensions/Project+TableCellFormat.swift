//
//  Project+FormatForTableCell.swift
//  Swift Searcher
//

import UIKit

extension Project {
    func tableCellFormat() -> NSAttributedString {
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
            NSAttributedString.Key.foregroundColor: UIColor.purple
        ]
        
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)
        ]
        
        let titleString = NSMutableAttributedString(string: "Project \(projectNumber): \(title)\n", attributes: nameAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
}
