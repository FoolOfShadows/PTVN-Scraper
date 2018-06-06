//
//  VisitData.swift
//  PTVN Scraper
//
//  Created by Fool on 2/15/18.
//  Copyright © 2018 Fulgent Wake. All rights reserved.
//

import Foundation

class VisitData {
	var dateOfBirth:String
	var ptName:String
    var pharmacy:String
	var tasks:[String]
    
    init(dob: String, name:String, pharmacy:String = "", tasks:[String]) {
        self.dateOfBirth = dob
        self.ptName = name
        self.pharmacy = pharmacy
        self.tasks = tasks
    }

}

extension VisitData {
	func reportOutput() -> String {
		return "\(self.ptName) DOB \(self.dateOfBirth)\n\(self.pharmacy)\n\(addCharactersToFront(self.tasks.joined(separator: "\n"), theCharacters: "- "))"
	}
}
