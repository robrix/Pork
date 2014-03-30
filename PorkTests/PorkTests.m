//  Copyright (c) 2014 Rob Rix. All rights reserved.
//  Stub so that the test bundle builds.
@interface PORKTests : XCTestCase
@end

@implementation PORKTests

+(id)defaultTestSuite {
	return [L3TestSuite suiteForExecutablePath:@L3_BUNDLE_LOADER];
}

@end
