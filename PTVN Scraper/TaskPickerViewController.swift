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
	var tableArray = [String]()
	var chosenItems = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
		selectTasksTableView.dataSource = self
		selectTasksTableView.delegate = self
		
		for item in visitDataArray {
			if !item.tasks.isEmpty && item.tasks != [""] {
				resultsDict[item.ptName] = cleanTheSelection(item.tasks, badBits: badBits)
			}
		}
		for item in resultsDict {
			for task in item.value {
				tableArray.append("\(item.key): \(task)")
			}
		}
		//print(tableArray)
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
		return tableArray.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
		//print(potentialTasks[9])
		vw.textField?.stringValue = tableArray[row]
		
		return vw
	}
	
	@IBAction func getDataFromSelectedRow(_ sender:Any) {
		let currentRow = selectTasksTableView.row(for: sender as! NSView)
		//print(currentRow)
		if (sender as! NSButton).state == .on {
			chosenItems.append(tableArray[currentRow])
		} else if (sender as! NSButton).state == .off {
			chosenItems = chosenItems.filter { $0 != tableArray[currentRow] }
		}
		//print(chosenMeds)
		
	}
	
	@IBAction func continueWithSelectedItems(_ sender: Any) {
		let originatingVC = presenting as! criteriaViewController
		originatingVC.chosenItems = chosenItems
		//print("You have chosen:\n\(chosenItems)")
		chosenItems = [String]()
		self.dismiss(self)
	}
	
}
