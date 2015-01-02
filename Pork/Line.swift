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


func contiguous(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.minY - line2.bounds.maxY) < 10
}


// MARK: - Imports

import Quartz
