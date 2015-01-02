//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class SplitViewController: NSSplitViewController {
	override var representedObject: AnyObject? {
		didSet {
			for each in childViewControllers as [NSViewController] {
				each.representedObject = representedObject
			}
		}
	}
}


// MARK: - Imports

import Cocoa
