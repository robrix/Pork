//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func dehyphenateLine(line: Line, intoAttributedString string: NSMutableAttributedString) -> NSMutableAttributedString {
	if string.string.hasSuffix("-") {
		if isDictionaryWord(wordInString(string.string, backwards: true)) && isDictionaryWord(wordInString(line.attributedString.string, backwards: false)) {
			string.appendAttributedString(line.attributedString)
		} else {
			string.replaceCharactersInRange(NSRange(location: string.length - 1, length: 1), withAttributedString: line.attributedString)
		}
	} else if string.length > 0 {
		string.appendAttributedString(NSAttributedString(string: " "))
		string.appendAttributedString(line.attributedString)
	} else {
		string.appendAttributedString(line.attributedString)
	}
	return string
}

public func isDictionaryWord(word: String) -> Bool {
	return dictionaryWords.containsObject(word)
}

public func wordInString(string: String, #backwards: Bool) -> String {
	if var range = string.rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet(), options: backwards ? .BackwardsSearch : NSStringCompareOptions(0)) {
		if distance(range.startIndex, range.endIndex) == 0 {
			range = string.startIndex..<(backwards ? string.startIndex : string.endIndex)
		}

		return backwards ?
			string.substringWithRange(range.endIndex..<string.endIndex.predecessor())
			:	string.substringToIndex(range.startIndex)
	}
	return ""
}

public var dictionaryWords: NSSet = {
	var lines: [String] = []
	NSString(contentsOfFile:"/usr/share/dict/words", encoding: NSUTF8StringEncoding, error:nil)?.enumerateLinesUsingBlock { line, _ in
		lines.append(line)
	}
	return NSSet(array: lines)
}()


// MARK: - Imports

import Cocoa
