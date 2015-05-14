//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Line: Comparable {
	init(_ attributedString: NSAttributedString, _ bounds: CGRect) {
		self.attributedString = attributedString
		self.bounds = bounds
	}

	init(_ selection: PDFSelection, _ defaultAttributes: [String: NSObject]) {
		let string = NSMutableAttributedString(string: "", attributes: defaultAttributes)
		string.appendAttributedString(selection.attributedString())
		self.init(string, selection.boundsForPage(selection.pages().first as! PDFPage))
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


let maximalProximity: CGSize = CGSize(width: 30, height: 10)

func verticallyProximal(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.minY - line2.bounds.maxY) < maximalProximity.height
}

func horizontallyCoincident(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.width - line2.bounds.width) < maximalProximity.width
}

func alignedAtLeft(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.minX - line2.bounds.minX) < maximalProximity.width
}

func nonJustifiedTerminalLine(line1: Line, line2: Line) -> Bool {
	return alignedAtLeft(line1, line2) && line1.bounds.width > line2.bounds.width
}

func typeSize(line: Line) -> CGFloat? {
	let attributes = line.attributedString.fontAttributesInRange(NSRange(location: 0, length: 1))
	let fontSize: CGFloat? = ((attributes[NSFontSizeAttribute] as? NSNumber)?.doubleValue).map { CGFloat($0) }
	let font = (attributes[NSFontAttributeName] as? NSFont)
	return fontSize ?? font?.pointSize
}

func sameTypeSize(line1: Line, line2: Line) -> Bool {
	let (size1, size2) = (typeSize(line1), typeSize(line2))
	return size1 == size2 || (size1.map { size1 in size2.map { size2 in CGFloat.abs(size1 - size2) < 1 } ?? false } ?? false)
}

func contiguous(line1: Line, line2: Line) -> Bool {
	return verticallyProximal(line1, line2) && (horizontallyCoincident(line1, line2) || nonJustifiedTerminalLine(line1, line2)) && sameTypeSize(line1, line2)
}


// MARK: - Imports

import Quartz
