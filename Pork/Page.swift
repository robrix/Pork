//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Page {
	init(page: PDFPage) {
		self.page = page
	}

	var columns: [Column] = []

	private mutating func columnForLine(line: Line) -> Array<Column>.Index? {
		return columnForLine(byLeftEdge: line) ?? columnForLine(byCentre: line)
	}

	private func columnForLine(byLeftEdge line: Line) -> Array<Column>.Index? {
		return bestColumnForLine(line, 20) {
			CGFloat.abs($0.bounds.minX - line.bounds.minX)
		}
	}

	private func columnForLine(byCentre line: Line) -> Array<Column>.Index? {
		return bestColumnForLine(line, 10) {
			CGFloat.abs($0.bounds.midX - line.bounds.midX)
		}
	}

	private func bestColumnForLine(line: Line, _ maxAllowableDistance: CGFloat, _ metric: Column -> CGFloat) -> Array<Column>.Index? {
		var bestDistance = CGFloat.infinity
		return reduce(enumerate(columns), nil) {
			if CGFloat.abs($1.element.bounds.minY - line.bounds.maxY) > maxAllowableDistance { return $0 }
			let distance = metric($1.element)
			if distance < min(maxAllowableDistance, bestDistance) {
				bestDistance = distance
				return $1.index
			}
			return $0
		}
	}


	var lines: [Line] {
		return reduce(columns, []) { $0 + $1.lines }
	}

	mutating func addLine(line: Line) {
		if let index = columnForLine(line) {
			columns[index].lines.append(line)
		} else {
			var column = Column()
			column.lines.append(line)
			columns.append(column)
		}
	}


	// MARK: Private

	private let page: PDFPage
}


// MARK: - Imports

import Quartz
