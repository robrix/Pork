//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Column: Comparable {
	var lines: [Line] = []

	var bounds: CGRect {
		return reduce(map(lines) { $0.bounds }, CGRect.nullRect) {
			$0.rectByUnion($1)
		}
	}
}

public func == (left: Column, right: Column) -> Bool {
	return left.lines == right.lines
}

public func < (left: Column, right: Column) -> Bool {
	if left.bounds.minX == right.bounds.minX {
		return left.bounds.maxY > right.bounds.minY
	} else {
		return left.bounds.maxX < right.bounds.minX
	}
}


// MARK: - Imports

import Quartz
