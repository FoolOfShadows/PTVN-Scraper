//
//  TaskPickerModel.swift
//  PTVN Scraper
//
//  Created by Fool on 2/20/18.
//  Copyright © 2018 Fulgent Wake. All rights reserved.
//

import Foundation

let badBits = ["Tests ordered:", "Referrals made to:",]

//Clean extraneous text from the sections
func cleanTheSelection(_ theSection:[String], badBits:[String]) -> [String] {
	var selection = theSection
	for bit in badBits {
		selection = selection.filter {($0.removeWhiteSpace() != bit) && ($0.removeWhiteSpace() != "")}
	}
	
	return selection
//	var cleanedText = theSection.removeWhiteSpace()
//	for theBit in badBits {
//		cleanedText = cleanedText.replacingOccurrences(of: theBit, with: "")
//	}
//	cleanedText = cleanedText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//	return cleanedText
}
