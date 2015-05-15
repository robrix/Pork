//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func readjoinDecomposedDiacriticals(string: NSAttributedString) -> NSAttributedString {
	let string = string.mutableCopy() as! NSMutableAttributedString
	separatedDiacriticalExpression?.enumerateMatchesInString(string.string, options: nil, range: NSRange(string)) { result, _, _ in
		if result.rangeAtIndex(2).length > 0 {
			string.replaceCharactersInRange(result.rangeAtIndex(2), withString: (string.string as NSString).substringWithRange(result.rangeAtIndex(2)) + "\u{0308}")
			string.replaceCharactersInRange(result.rangeAtIndex(1), withString: "")
		} else {
			string.replaceCharactersInRange(result.range, withString: "\u{0308}")
		}
	}
	return string
}


let separatedDiacriticalExpression = NSRegularExpression(pattern: "(\u{0020}[\u{0300}-\u{036f}])([aeiouAEIOU])?", options: nil, error: nil)


import Cocoa
