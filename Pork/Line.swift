//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Line: Comparable {
	init(_ attributedString: NSAttributedString, _ bounds: CGRect) {
		self.attributedString = attributedString
		self.bounds = bounds
	}

	init(_ selection: PDFSelection, _ defaultAttributes: [String: NSObject]) {
		let string = selection.attributedString().mutableCopy() as! NSMutableAttributedString
		string.addAttributes(defaultAttributes, range: NSRange(string))
		self.init(string, selection.boundsForPage(selection.pages().first as! PDFPage))
	}

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

func verticallyProximal(line1: ((index: Int, element: Column), (index: Int, element: Line)), line2: ((index: Int, element: Column), (index: Int, element: Line))) -> Bool {
	return
		CGFloat.abs(line1.1.element.bounds.minY - line2.1.element.bounds.maxY) < maximalProximity.height
	||	(!line1.1.element.complete && inSuccessiveColumns(line1, line2) && atEndOfColumn(line1) && atStartOfColumn(line2))
}

func horizontallyCoincident(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.width - line2.bounds.width) < maximalProximity.width
}

func alignedAtLeft(line1: Line, line2: Line) -> Bool {
	return CGFloat.abs(line1.bounds.minX - line2.bounds.minX) < maximalProximity.width
}

func nonJustifiedTerminalLine(line1: Line, line2: Line) -> Bool {
	return alignedAtLeft(line1, line2) && line1.bounds.width > (line2.bounds.width - maximalProximity.width)
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

func inSuccessiveColumns(line1: ((index: Int, element: Column), (index: Int, element: Line)), line2: ((index: Int, element: Column), (index: Int, element: Line))) -> Bool {
	return line1.0.index + 1 == line2.0.index
}

func atEndOfColumn(line: ((index: Int, element: Column), (index: Int, element: Line))) -> Bool {
	return line.1.index + 1 == line.0.element.lines.count
}

func atStartOfColumn(line: ((index: Int, element: Column), (index: Int, element: Line))) -> Bool {
	return line.1.index == 0
}

func contiguous(line1: ((index: Int, element: Column), (index: Int, element: Line)), line2: ((index: Int, element: Column), (index: Int, element: Line))) -> Bool {
	if !verticallyProximal(line1, line2) { return false }
	return
		horizontallyCoincident(line1.1.element, line2.1.element)
	||	nonJustifiedTerminalLine(line1.1.element, line2.1.element) && sameTypeSize(line1.1.element, line2.1.element)
}


import Quartz
