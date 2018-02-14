//
//  resultsViewController.swift
//  ScriptsFromPTVNs
//
//  Created by Fool on 2/8/18.
//  Copyright © 2018 Fulgent Wake. All rights reserved.
//

import Cocoa

class resultsViewController: NSViewController {
	@IBOutlet var resultsView: NSTextView!
	var results = String()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		let theUserFont:NSFont = NSFont.systemFont(ofSize: 18)
		let fontAttributes = NSDictionary(object: theUserFont, forKey: kCTFontAttributeName as! NSCopying)
//		let fontAttributes = NSDictionary(object: theUserFont, forKey: NSFontAttributeName as NSCopying)
		resultsView.typingAttributes = fontAttributes as! [NSAttributedStringKey : Any]
		resultsView.string = "NEEDED SCRIPTS\n\(results)"
    }
    
}
