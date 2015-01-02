//  Copyright (c) 2015 Rob Rix. All rights reserved.

struct File {
	init(document: PDFDocument) {
		self.document = document
		pages = map(0..<document.pageCount()) { Page(page: document.pageAtIndex($0)) }

		for selection in document.selectionForEntireDocument().selectionsByLine() as [PDFSelection] {
			pages[document.indexForPage(selection.pages().first as PDFPage)].addLine(Line(selection))
		}

		for (index, page) in enumerate(pages) {
			for (columnIndex, column) in enumerate(page.columns) {
				sort(&pages[index].columns[columnIndex].lines)
			}
			sort(&pages[index].columns)
		}
	}


	let document: PDFDocument
	var pages: [Page] = []

	var lines: [Line] {
		get { return reduce(pages, []) { $0 + $1.lines } }
	}

	var attributedString: NSAttributedString {
		return reduce(lines, NSMutableAttributedString()) {
			dehyphenateLine($1.attributedString, intoAttributedString: $0)
		}
	}
}


// MARK: - Imports

import Cocoa
import Quartz
