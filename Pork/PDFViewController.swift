//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class PDFViewController: NSViewController {
	var pdfView: PDFView {
		return view as! PDFView
	}

	override var representedObject: AnyObject? {
		didSet {
			if let document = representedObject as? Document, pdfDocument = document.document, file = document.file {
				pdfView.setDocument(pdfDocument)

				var pageIndex = 0
				let pdfPages = GeneratorOf {
					pageIndex < pdfDocument.pageCount() ? pdfDocument.pageAtIndex(pageIndex++) : nil
				}

				for (pdfPage, page) in zip(pdfPages, file.pages) {
					for column in page.columns {
						let annotation = PDFAnnotationSquare(bounds: column.bounds)
						annotation.setColor(NSColor.greenColor())
						pdfPage.addAnnotation(annotation)
					}
				}
			}
		}
	}
}


// MARK: - Imports

import Quartz
