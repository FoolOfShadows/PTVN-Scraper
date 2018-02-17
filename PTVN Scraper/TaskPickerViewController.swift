//
//  TaskPickerViewController.swift
//  PTVN Scraper
//
//  Created by Fool on 2/15/18.
//  Copyright © 2018 Fulgent Wake. All rights reserved.
//

import Cocoa

class TaskPickerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
	@IBOutlet weak var selectTasksTableView: NSTableView!
	
	var visitDataArray = [VisitData]()
	var patients = [String]()
	var potentialTasks = [[String]]()
	var resultsDict = [String:[String]]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
		print("Hi")
		selectTasksTableView.dataSource = self
		selectTasksTableView.delegate = self
		
		for item in visitDataArray {
			if !item.tasks.isEmpty && item.tasks != [""] {
				resultsDict[item.ptName] = item.tasks
			}
		}
		print(resultsDict)
	}
	
//	func tableView(tableView: NSTableView, sectionForRow row: Int) -> (section: Int, row: Int) {
//
//	}
//	func numberOfSections(in tableView: NSTableView) -> Int {
//		return patients.count
//	}
//
//	func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
//		
//	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return resultsDict.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
		//print(potentialTasks[9])
		vw.textField?.stringValue = Array(resultsDict.keys)[row]
		
		return vw
	}
}
