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
	return
		CGFloat.abs(line1.line.element.bounds.minY - line2.line.element.bounds.maxY) < maximalProximity.height
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

func inSuccessiveColumns(line1: LineContext, line2: LineContext) -> Bool {
	return line1.column.index + 1 == line2.column.index
}

func atEndOfColumn(line: LineContext) -> Bool {
	return line.line.index + 1 == line.column.element.lines.count
}

func atStartOfColumn(line: LineContext) -> Bool {
	return line.line.index == 0
}

func contiguous(line1: LineContext, line2: LineContext) -> Bool {
	if !verticallyProximal(line1, line2) { return false }
	return
		horizontallyCoincident(line1, line2)
	||	nonJustifiedTerminalLine(line1.line.element, line2.line.element) && sameTypeSize(line1.line.element, line2.line.element)
}


import Quartz
