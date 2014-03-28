//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "PORKLine.h"

@implementation PORKLine

-(instancetype)initWithSelection:(PDFSelection *)selection {
	NSParameterAssert(selection != nil);
	NSParameterAssert(selection.pages.count == 1);
	
	if ((self = [super init])) {
		_selection = selection;
		_page = selection.pages.firstObject;
	}
	return self;
}


-(NSString *)string {
	return self.selection.string;
}

-(NSAttributedString *)attributedString {
	return self.selection.attributedString;
}


-(CGRect)bounds {
	return [self.selection boundsForPage:self.page];
}

-(CGFloat)top {
	return CGRectGetMaxY(self.bounds);
}

-(CGFloat)left {
	return CGRectGetMinX(self.bounds);
}

-(CGFloat)centre {
	return CGRectGetMidX(self.bounds);
}


-(NSComparisonResult)compare:(PORKLine *)other {
	NSComparisonResult ordering = NSOrderedSame;
	// comparing by tops only; is this what we actually intend?
	if (self.top > other.top) return NSOrderedAscending;
	else if (other.top > self.top) return NSOrderedDescending;
	return ordering;
}

@end
