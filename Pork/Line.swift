//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Line: Comparable {
	init(_ selection: PDFSelection, _ defaultAttributes: [String: NSObject]) {
		let string = selection.attributedString().mutableCopy() as! NSMutableAttributedString
		string.addAttributes(defaultAttributes, range: NSRange(string))
		self.selection = selection
		self.attributedString = string
		self.bounds = selection.boundsForPage(selection.pages().first as! PDFPage)
	}

	let selection: PDFSelection
	let attributedString: NSAttributedString
	let bounds: CGRect

	var complete: Bool {
		return attributedString.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).hasSuffix(".")
	}
}

public func == (left: Line, right: Line) -> Bool {
	return left.bounds == right.bounds
}

public func < (left: Line, right: Line) -> Bool {
	return left.bounds.minY > right.bounds.minY
}


let maximalProximity: CGSize = CGSize(width: 20, height: 10)

typealias LineContext = (column: (index: Int, element: Column), line: (index: Int, element: Line))

func verticallyProximal(line1: LineContext, line2: LineContext) -> Bool {
	let proximity = max(lineHeight(line1.line.element), lineHeight(line2.line.element), maximalProximity.height)
	return
		CGFloat.abs(line1.line.element.bounds.minY - line2.line.element.bounds.maxY) < proximity
	||	(!line1.line.element.complete && inSuccessiveColumns(line1, line2) && atEndOfColumn(line1) && atStartOfColumn(line2))
}

func horizontallyCoincident(line1: LineContext, line2: LineContext) -> Bool {
	return
		CGFloat.abs(line1.column.element.bounds.width - line2.column.element.bounds.width) < maximalProximity.width
	&&	CGFloat.abs(line1.column.element.bounds.width - line1.line.element.bounds.width) < maximalProximity.width
	&&	CGFloat.abs(line2.column.element.bounds.width - line2.line.element.bounds.width) < maximalProximity.width
}

func alignedAtLeft(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.minX - line2.bounds.minX) < maximalProximity.width
}

func nonJustifiedTerminalLine(line1: Line, line2: Line) -> Bool {
	return alignedAtLeft(line1, line2) && line1.bounds.width > (line2.bounds.width + maximalProximity.width)
}

func lineHeight(line: Line) -> CGFloat {
	var size = line.bounds.height
	line.attributedString.enumerateAttributesInRange(NSRange(line.attributedString), options: nil) { attributes, _, _ in
		let fontSize: CGFloat? = ((attributes[NSFontSizeAttribute] as? NSNumber)?.doubleValue).map { CGFloat($0) }
		let font = attributes[NSFontAttributeName] as? NSFont
		if let s = fontSize ?? font?.pointSize { size = max(size, s) }
	}
	return round(size)
}

func sameLineHeight(line1: Line, line2: Line) -> Bool {
	let (size1, size2) = (lineHeight(line1), lineHeight(line2))
	return abs(size1 - size2) < 5
}

func inSuccessiveColumns(line1: LineContext, line2: LineContext) -> Bool {
	return line1.column.index + 1 == line2.column.index
}

func atEndOfColumn(line: LineContext) -> Bool {
	return line.line.index + 1 == line.column.element.lines.count
}

func atStartOfColumn(line: LineContext) -> Bool {
	return line.line.index == 0
}

func centred(line: LineContext) -> Bool {
	let (columnBounds, lineBounds) = (line.column.element.bounds, line.line.element.bounds)
	let centred =
		CGFloat.abs(columnBounds.width - lineBounds.width) > maximalProximity.width
	&&	CGFloat.abs(columnBounds.midX - lineBounds.midX) < maximalProximity.width
	return centred
}

func contiguous(line1: LineContext, line2: LineContext) -> Bool {
	if !verticallyProximal(line1, line2) { return false }
	if !sameLineHeight(line1.line.element, line2.line.element) { return false }
	return
		horizontallyCoincident(line1, line2)
	||	centred(line1) && centred(line2)
	||	nonJustifiedTerminalLine(line1.line.element, line2.line.element)
}


import Quartz
