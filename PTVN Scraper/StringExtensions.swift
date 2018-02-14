//
//  StringExtensions.swift
//  PTVN to PF 2
//
//  Created by Fool on 1/10/17.
//  Copyright © 2017 Fulgent Wake. All rights reserved.
//

import Foundation

extension String {
	func findRegexMatchFrom(_ start: String, to end:String) -> String? {
		guard let startRegex = try? NSRegularExpression(pattern: start, options: []) else { return nil }
		guard let endRegex = try? NSRegularExpression(pattern: end, options: []) else {return nil }
		let startMatch = startRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
		let endMatch = endRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
		
		let startRange = startMatch[0].range
		let endRange = endMatch[0].range
		
		let r = self.index(self.startIndex, offsetBy: startRange.location) ..< self.index(self.startIndex, offsetBy: endRange.location + endRange.length)
		
		return self.substring(with: r)
	}
	
	
	func findRegexMatchBetween(_ start: String, and end: String) -> String? {
		guard let startRegex = try? NSRegularExpression(pattern: start, options: []) else { return nil }
		Swift.print(startRegex)
		guard let endRegex = try? NSRegularExpression(pattern: end, options: []) else {return nil }
		Swift.print(endRegex)
		
		let startMatch = startRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
		Swift.print(startMatch)
		let endMatch = endRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
		Swift.print(endMatch)
		
		if !startMatch.isEmpty && !endMatch.isEmpty {
			
			let startRange = startMatch[0].range
			Swift.print(startRange)
			let endRange = endMatch[0].range
			Swift.print(endRange)
			
			if startRange.location > endRange.location {
				return "There is a formatting error in this patients PTVN."
			} else {
				let r = self.index(self.startIndex, offsetBy: startRange.location + startRange.length) ..< self.index(self.startIndex, offsetBy: endRange.location)
				
				return self.substring(with: r)
			}
		} else {
			return "There was no match for either '\(start)' or '\(end)' in the text."
		}
		
	}
	
	
	func removeWhiteSpace() -> String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}
	
	mutating func checkDateComponentForExtraCharacter() -> String {
		if self.count > 6 {
			self.remove(at: self.index(before: self.endIndex))
		}
		return self
	}
	
}

extension URL {
	func urlIntoCleanString() -> String? {
		return self.deletingPathExtension().absoluteString.removingPercentEncoding
	}
	
	func splitFileNameIntoComponents() -> [String]? {
		if let nameWithoutPercentEncoding = self.urlIntoCleanString() {
			return nameWithoutPercentEncoding.components(separatedBy: " ")
		}
		return nil
	}
	
	func getFilesInDirectoryWhereNameContains(_ criteria:[String]) -> [URL] {
		let fileManager = FileManager.default
		var results = [URL]()
		
		let enumeratorOptions: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
		let theEnumerator = fileManager.enumerator(at: self, includingPropertiesForKeys: nil, options: enumeratorOptions, errorHandler: nil)
		for item in theEnumerator!.allObjects {
			//print(item)
			if let itemURL = item as? URL {
				for crit in criteria {
					//Have to remove percent encoding to check for naming
					//convention items with spaces on either side
					if itemURL.absoluteString.removingPercentEncoding!.contains(crit) {
						results.append(itemURL)
					}
				}
			}
		}
		//print("Directory Files:\n\n\n\(results.count)\n\n\n")
		return results
	}
}
