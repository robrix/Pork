//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Pork
import XCTest

final class HyphenationTests: XCTestCase {
	func testDictionaryWords() {
		XCTAssertTrue(isDictionaryWord("context"))
		XCTAssertTrue(isDictionaryWord("free"))
		XCTAssertFalse(isDictionaryWord("hyph"))
	}
}
