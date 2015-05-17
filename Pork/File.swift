//  Copyright (c) 2015 Rob Rix. All rights reserved.

struct File {
	init(document: PDFDocument) {
		self.document = document
		pages = map(0..<document.pageCount()) { Page(page: document.pageAtIndex($0)) }

		for selection in document.selectionForEntireDocument().selectionsByLine() as! [PDFSelection] {
			pages[document.indexForPage(selection.pages().first as! PDFPage)].addLine(Line(selection, defaultAttributes))
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
		return reduce(pages, []) { $0 + $1.lines }
	}

	var paragraphs: [Paragraph] {
		let lines: [((Int, Column), (Int, Line))] = reduce(enumerate(flatMap(pages) { $0.columns }), []) { all, column in
			all + map(enumerate(column.element.lines)) {
				(column, $0)
			}
		}
		return map(split(lines[indices(lines)], contiguous)) {
			Paragraph(lines: Array(map($0) { $0.1.1 }))
		}
	}

	var defaultParagraphStyle: NSParagraphStyle {
		let style = NSMutableParagraphStyle()
		style.lineHeightMultiple = 1.3
		style.lineBreakMode = .ByWordWrapping
		style.paragraphSpacing = 15
		style.firstLineHeadIndent = 15
		style.tabStops = []
		return style
	}

	var defaultAttributes: [String: NSObject] {
		return [
			NSParagraphStyleAttributeName: defaultParagraphStyle,
		]
	}

	var attributedString: NSAttributedString {
		let separator = NSAttributedString(string: "\u{2029}", attributes: defaultAttributes)
		return reduce(paragraphs, NSMutableAttributedString(string: "", attributes: defaultAttributes)) {
			if $0.length > 0 { $0.appendAttributedString(separator) }
			$0.appendAttributedString($1.attributedString)
			return $0
		}
	}
}


func split<S: Sliceable where S.SubSlice == S>(elements: S, contiguous: (S.Generator.Element, S.Generator.Element) -> Bool) -> [S.SubSlice] {
	if isEmpty(elements) { return [] }
	for index in elements.startIndex.successor()..<elements.endIndex {
		let (previous, current) = (elements[advance(elements.startIndex, distance(elements.startIndex, index) - 1, elements.endIndex)], elements[index])
		if !contiguous(previous, current) {
			return [ elements[elements.startIndex..<index] ] + split(elements[index..<elements.endIndex], contiguous)
		}
	}
	return [ elements[indices(elements)] ]
}


import Quartz
