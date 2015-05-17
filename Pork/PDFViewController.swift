//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class PDFViewController: NSViewController {
	var pdfView: PDFView {
		return view as! PDFView
	}

	override var representedObject: AnyObject? {
		didSet {
			if let document = representedObject as? Document, pdfDocument = document.document, file = document.file {
				pdfView.setDocument(pdfDocument)
			}
		}
	}
}


// MARK: - Imports

import Quartz
