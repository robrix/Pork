//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Line: Comparable {
	init(_ attributedString: NSAttributedString, _ bounds: CGRect) {
		self.attributedString = attributedString
		self.bounds = bounds
	}

	init(_ selection: PDFSelection) {
		self.init(selection.attributedString(), selection.boundsForPage(selection.pages().first as PDFPage))
	}

	let attributedString: NSAttributedString
	let bounds: CGRect
}

public func == (left: Line, right: Line) -> Bool {
	return left.bounds == right.bounds
}

public func < (left: Line, right: Line) -> Bool {
	return left.bounds.minY > right.bounds.minY
}


// MARK: - Imports

import Quartz
