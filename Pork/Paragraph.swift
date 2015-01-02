//  Copyright (c) 2015 Rob Rix. All rights reserved.

struct Paragraph {
	var lines: [Line] = []

	var attributedString: NSAttributedString {
		return reduce(lines, NSMutableAttributedString()) {
			dehyphenateLine($1.attributedString, intoAttributedString: $0)
		}
	}
}


// MARK: - Imports

import Cocoa
