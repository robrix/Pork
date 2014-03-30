//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "PORKLine.h"

@implementation PORKLine

-(instancetype)initWithAttributedString:(NSAttributedString *)attributedString bounds:(CGRect)bounds {
	NSParameterAssert(attributedString != nil);
	
	if ((self = [super init])) {
		_attributedString = [attributedString copy];
		_bounds = bounds;
	}
	return self;
}

-(instancetype)initWithSelection:(PDFSelection *)selection {
	NSParameterAssert(selection != nil);
	NSParameterAssert(selection.pages.count == 1);
	
	if ((self = [self initWithAttributedString:selection.attributedString bounds:[selection boundsForPage:selection.pages.firstObject]])) {
		_selection = selection;
		_page = selection.pages.firstObject;
	}
	return self;
}


-(NSString *)string {
	return self.attributedString.string;
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
