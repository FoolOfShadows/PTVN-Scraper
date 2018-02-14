//
//  criteriaViewController.swift
//  ScriptsFromPTVNs
//
//  Created by Fool on 2/8/18.
//  Copyright © 2018 Fulgent Wake. All rights reserved.
//

import Cocoa

class criteriaViewController: NSViewController {

	@IBOutlet weak var timeSelectorMatrix: NSMatrix!
	@IBOutlet weak var currentDate: NSTextField!
	@IBOutlet weak var onDate: NSDatePicker!
	@IBOutlet weak var afterDate: NSDatePicker!
	@IBOutlet weak var betweenStartDate: NSDatePicker!
	@IBOutlet weak var betweenEndDate: NSDatePicker!

	
	var basePath = NSHomeDirectory()
	var selectorTag = Int()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let today = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "M/d/yy"
		currentDate.stringValue = formatter.string(from: today)
		onDate.dateValue = Date()
		afterDate.dateValue = Date()
		betweenStartDate.dateValue = Date()
		betweenEndDate.dateValue = Date()
    }
	
	func processTheDirectory() -> [URL] {
		if let theSelectorTag = timeSelectorMatrix.selectedCell()?.tag {
			selectorTag = theSelectorTag
		}
		
		/*Addend the path to the WPCMSharedFiles folder for the office machines to create a default selection.
		This requires all the computers this code runs on to have a folder named WPCMSharedFiles
		in their home directory.*/
		var originFolderURL: URL
		switch selectorTag {
		case 0:
			originFolderURL = URL(fileURLWithPath: "\(basePath)/WPCMSharedFiles/zDoctor Review/06 Dummy Files")
		default:
			originFolderURL = URL(fileURLWithPath: "\(basePath)/WPCMSharedFiles/zDonna Review/01 PTVN Files")
		}
		
		print("\(originFolderURL)")
		return originFolderURL.getFilesInDirectoryWhereNameContains(["PTVN"])
		//return getFilesFromDirectory(originFolderURL, whereNameIncludes: ["PTVN"])
	}
	
	func takeFind() -> String {
		var theResults = String()
		let theFileURLs = processTheDirectory()
		switch selectorTag {
		case 0:
			let today = Date()
			theResults = processTheFiles(getFileNamesFrom(theFileURLs, forDate: (start: today, end: nil), status: .on))
		case 1:
			theResults = processTheFiles(getFileNamesFrom(theFileURLs, forDate: (start: onDate.dateValue, end: nil), status: .on))
		case 2:
			theResults = processTheFiles(getFileNamesFrom(theFileURLs, forDate: (start: afterDate.dateValue, end: nil), status: .after))
		case 3:
			theResults = processTheFiles(getFileNamesFrom(theFileURLs, forDate: (start: betweenStartDate.dateValue, end: betweenEndDate.dateValue), status: .between))
		default:
			return "Failed to identify files to process"
		}
		
		return theResults
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		if segue.identifier!.rawValue == "showReport" {
			if let toViewController = segue.destinationController as? resultsViewController {
				toViewController.results = takeFind()
			}
		}
	}
}
