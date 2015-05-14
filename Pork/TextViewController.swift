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
			f.flatMap { s.map($0) }
		}
	}
}


import Cocoa
