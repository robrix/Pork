//  Copyright (c) 2015 Rob Rix. All rights reserved.

extension NSRange {
	init(_ string: NSAttributedString) {
		self.init(location: 0, length: string.length)
	}
}


import Cocoa
