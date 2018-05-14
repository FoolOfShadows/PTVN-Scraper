//
//  DataProcessingModel.swift
//  ScriptsFromPTVNs
//
//  Created by Fool on 2/8/18.
//  Copyright © 2018 Fulgent Wake. All rights reserved.
//

import Cocoa

enum TimeMatched {
	case on
	case before
	case after
	case between
}

func getFileNamesFrom(_ files: [URL], forDate date:(start:Date, end:Date?), status:TimeMatched) -> [URL] {
	//print("Getting matching file names")
	//Convert URL array to String array using compactMap (which replaces flatMap) to filter out nil values
	//let filesAsStrings = files.compactMap {$0.urlIntoCleanString()}
	let formatter = DateFormatter()
	formatter.dateFormat = "yyMMdd"
	var results = [URL]()
	print(formatter.string(from: date.start))
	switch status {
	case .on: results = files.filter{$0.absoluteString.contains(formatter.string(from: date.start))}
	case .before: results = []
	case .after:
		for item in files {
			guard let itemDate = item.splitFileNameIntoComponents()?.last,
				  let dateInt = Int(itemDate),
				  let startInt = Int(formatter.string(from: date.start)) else { continue }
			if dateInt >= startInt {
				results.append(item)
			}
		}
	case .between:
		for item in files {
			guard let itemDate = item.splitFileNameIntoComponents()?.last,
				let dateInt = Int(itemDate),
				let startInt = Int(formatter.string(from: date.start)),
				let endInt = Int(formatter.string(from: date.end!)) else { continue }
			if dateInt >= startInt && dateInt <= endInt {
				results.append(item)
			}
		}
	}
	//print("Matching files: \(results)")
	return results
}

func processTheFiles(_ theFiles:[URL]?) -> [VisitData] {
    //print("Processing the files")
    var neededRxs = [VisitData]()
    //var results = ""
    if let thePTVNText = theFiles {
        for file in thePTVNText {
            
            do {
                let ptvnContents = try String(contentsOf: file, encoding: .utf8)
                //check if its a new or old style PTVN file
                //if it's old, do the following
                if ptvnContents.contains("#PTVNFILE#") {
                    let dobResults = getNewDOBInfo(ptvnContents)
                    let nameResults = getNewNameInfo(ptvnContents)
                    let markedResults = cleanTheSelection(getMarkedLines(ptvnContents), badBits: badBits)
                    if !markedResults.isEmpty {
                        neededRxs.append(VisitData(dob: dobResults, name: nameResults, tasks: markedResults))
                    }
                } else {
                    let rxResults = cleanTheSelection(getRxInfo(ptvnContents), badBits: badBits)
                    let dobResults = getDOBInfo(ptvnContents)
                    let nameResults = getNameInfo(ptvnContents)
                    let markedResults = cleanTheSelection(getMarkedLines(ptvnContents), badBits: badBits)
                    
                    if (!rxResults.isEmpty) && (!markedResults.isEmpty) {
                        neededRxs.append(VisitData(dob: dobResults, name: nameResults, tasks: rxResults + markedResults))
                    } else if (!rxResults.isEmpty) || (!markedResults.isEmpty) {
                        neededRxs.append(VisitData(dob: dobResults, name: nameResults, tasks: rxResults + markedResults))
                    }
                }
            } catch {
                print("Ended up in the CATCH clause")
            }
            //if it's new, process it with a new method
        }
    }
    //print(neededRxs)
    return neededRxs
}

func getNameInfo(_ theText:String) -> String {
	var nameInfo = ""
	
	let separatedText = theText.components(separatedBy: "\n")
	//print(separatedText)
	nameInfo = separatedText[0].removeWhiteSpace()
	
	return nameInfo
}

func getNewNameInfo(_ theText:String) -> String {
    guard let nameInfo = theText.findRegexMatchBetween("#PATIENTNAME", and: "PATIENTNAME#") else { return String() }
    return nameInfo.removeWhiteSpace()
}

func getDOBInfo(_ theText:String) -> String {
	var dobInfo = ""
	guard let rawDOBInfo = theText.findRegexMatchBetween("DOB:", and: "Age:") else { return "" }
	dobInfo = rawDOBInfo.removeWhiteSpace()
	return dobInfo
}

func getNewDOBInfo(_ theText:String) -> String {
    var dobInfo = String()
    guard let rawDOBInfo = theText.findRegexMatchBetween("#PATIENTDOB", and: "PATIENTDOB#") else { return dobInfo }
    dobInfo = rawDOBInfo.removeWhiteSpace()
    return dobInfo
}

func getRxInfo(_ theText:String) -> [String] {
	var rxInfo = ""
	guard let rawNeededScripts = theText.findRegexMatchBetween("\\*\\*Rx\\*\\*", and: "O\\(PE\\):") else { return [] }
	rxInfo = rawNeededScripts.removeWhiteSpace()
	let rxData = rxInfo.components(separatedBy: "\n")
	return rxData
}

func getMarkedLines(_ theText:String) -> [String] {
	var markedLines = [String]()
	//var results = String()
	let theLines = theText.components(separatedBy: "\n")
	for line in theLines {
		if line.contains("^^") {
			let cleanLine = cleanTheSections(line, badBits: ["^^"])
			markedLines.append(cleanLine)
		}
	}
	return markedLines
}

//Add specific characters to the beginning of each line
func addCharactersToFront(_ theText:String, theCharacters:String) ->String {
	var returnText = ""
	var newTextArray = [String]()
	let textArray = theText.components(separatedBy: "\n")
	let cleanedTextArray = textArray.filter({!$0.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty })
	for line in cleanedTextArray {
		let newLine = theCharacters + line
		newTextArray.append(newLine)
	}
	
	returnText = newTextArray.joined(separator: "\n")
	
	return returnText
}

//Clean extraneous text from the sections
func cleanTheSections(_ theSection:String, badBits:[String]) -> String {
	var cleanedText = theSection.removeWhiteSpace()
	for theBit in badBits {
		cleanedText = cleanedText.replacingOccurrences(of: theBit, with: "")
	}
	return cleanedText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}


