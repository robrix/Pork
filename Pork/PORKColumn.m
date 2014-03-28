//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "PORKColumn.h"
#import "PORKLine.h"

@implementation PORKColumn {
	NSMutableArray *_lines;
}

-(instancetype)initWithPage:(PDFPage *)page {
	NSParameterAssert(page != nil);
	
	if ((self = [super init])) {
		_page = page;
		_lines = [NSMutableArray new];
	}
	return self;
}


-(void)addLine:(PORKLine *)line {
	[_lines addObject:line];
	[_lines sortUsingSelector:@selector(compare:)];
}


-(NSString *)string {
	return [@"" red_append:REDMap(self.lines, ^(PORKLine *line) {
		return line.string;
	})];
}


-(NSRect)bounds {
	NSValue *nullRect = [NSValue valueWithRect:CGRectNull];
	return [[REDMap(self.lines, ^(PORKLine *line) {
		return [NSValue valueWithRect:line.bounds];
	}) red_reduce:nullRect usingBlock:^(NSValue *into, NSValue *each) {
		return [NSValue valueWithRect:CGRectUnion(into.rectValue, each.rectValue)];
	}] rectValue];
}

-(CGFloat)top {
	return CGRectGetMaxY(self.bounds);
}

-(CGFloat)bottom {
	return CGRectGetMinY(self.bounds);
}

-(CGFloat)left {
	return CGRectGetMinX(self.bounds);
}

-(CGFloat)right {
	return CGRectGetMaxX(self.bounds);
}

-(CGFloat)centre {
	return CGRectGetMidX(self.bounds);
}


-(NSComparisonResult)compareVertically:(PORKColumn *)other {
	NSComparisonResult ordering = NSOrderedSame;
	if (self.bottom > other.top) ordering = NSOrderedAscending;
	else if (other.bottom > self.top) ordering = NSOrderedDescending;
	return ordering;
}

-(NSComparisonResult)compareHorizontally:(PORKColumn *)other {
	NSComparisonResult ordering = NSOrderedSame;
	if (self.right < other.left)
		ordering = NSOrderedAscending;
	else if (other.right < self.left)
		ordering = NSOrderedDescending;
	return ordering;
}

-(NSComparisonResult)compare:(PORKColumn *)other {
	NSComparisonResult vertical = [self compareVertically:other];
	
	return vertical != NSOrderedSame?
	vertical
	:	[self compareHorizontally:other];
}

@end
