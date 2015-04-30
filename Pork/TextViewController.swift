//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class TextViewController: NSViewController {
	var scrollView: NSScrollView {
		return view as! NSScrollView
	}

	var textView: NSTextView {
		return scrollView.documentView as! NSTextView
	}

	override var representedObject: AnyObject? {
		didSet {
			let s = (representedObject as? Document)?.file?.attributedString
			let f = textView.textStorage?.setAttributedString
			f >>= { s >>= $0 }
		}
	}
}


infix operator >>= { associativity right }

func >>= <T, U> (left: T?, right: T -> U?) -> U? {
	return left.map(right) ?? nil
}


// MARK: - Imports

import Cocoa
