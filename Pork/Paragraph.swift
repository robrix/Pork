//  Copyright (c) 2015 Rob Rix. All rights reserved.

struct Paragraph {
	var lines: [Line] = []

	var attributedString: NSAttributedString {
		return reduce(lines, NSMutableAttributedString(string: "")) {
			dehyphenateLine(recomposeDiacriticals($1.attributedString), intoAttributedString: $0)
		}
	}
}


import Cocoa
