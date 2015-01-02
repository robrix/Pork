//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class PDFViewController: NSViewController {
	var pdfView: PDFView {
		return view as PDFView
	}

	override var representedObject: AnyObject? {
		didSet {
			(representedObject as? Document)?.document.map(pdfView.setDocument)
		}
	}
}


// MARK: - Imports

import Quartz
