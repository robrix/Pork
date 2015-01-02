//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class Document: NSDocument {
	var document: PDFDocument?
	var file: File?

	override func makeWindowControllers() {
		let storyboard = NSStoryboard(name: "Main", bundle: nil)!
		let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as NSWindowController
		windowController.contentViewController?.representedObject = self
		addWindowController(windowController)
	}

	override func readFromURL(url: NSURL, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		document = PDFDocument(URL: url)
		file = document.map { File(document: $0) }

		return document != nil
	}
}


// MARK: - Imports

import Quartz
