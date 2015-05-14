//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func readjoinDecomposedDiacriticals(string: NSAttributedString) -> NSAttributedString {
	return string
}


let separatedDiacriticalExpression = NSRegularExpression(pattern: "(\u{0020}[\u{0300}-\u{036f}])([aeiouAEIOU])?", options: nil, error: nil)


import Cocoa
