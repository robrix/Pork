//  Copyright (c) 2015 Rob Rix. All rights reserved.

struct Paragraph {
	var lines: [Line] = []

	func attributedString(defaultAttributes: [String: NSObject]) -> NSAttributedString {
		return reduce(lines, NSMutableAttributedString(string: "", attributes: defaultAttributes)) {
			dehyphenateLine($1.attributedString, intoAttributedString: $0)
		}
	}
}


import Cocoa
