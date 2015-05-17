//  Copyright (c) 2015 Rob Rix. All rights reserved.

struct Paragraph {
	var lines: [Line] = []

	var attributedString: NSAttributedString {
		return reduce(lines, NSMutableAttributedString(string: "")) {
			dehyphenateLine(readjoinDecomposedDiacriticals($1.attributedString), intoAttributedString: $0)
		}
	}

	var selection: PDFSelection? {
		let selections = lazy(lines).map { $0.selection }
		if let document = (selections.first?.pages() as? [PDFPage])?.first?.document() {
			let selection = PDFSelection(document: document)
			selection.addSelections(selections.array)
			return selection
		}
		return nil
	}
}


import Cocoa
import Quartz
