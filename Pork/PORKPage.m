//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "PORKPage.h"
#import "PORKColumn.h"
#import "PORKLine.h"

@implementation PORKPage {
	NSMutableArray *_columns;
}

-(instancetype)initWithPage:(PDFPage *)page {
	NSParameterAssert(page != nil);
	
	if ((self = [super init])) {
		_page = page;
		_columns = [NSMutableArray new];
	}
	return self;
}


-(PORKColumn *)bestColumnForLine:(PORKLine *)line usingBlock:(CGFloat(^)(PORKColumn *each, PORKLine *line))block {
	__block CGFloat bestDistance = INFINITY;
	CGFloat maxAllowableDistance = 10;
	return [self.columns red_reduce:nil usingBlock:^(PORKColumn *best, PORKColumn *each) {
		CGFloat distance = block(each, line);
		if (distance < MIN(maxAllowableDistance, bestDistance)) {
			best = each;
			bestDistance = distance;
		}
		return best;
	}];
}

-(PORKColumn *)columnForLineByLeftEdge:(PORKLine *)line {
	return [self bestColumnForLine:line usingBlock:^CGFloat(PORKColumn *each, PORKLine *line) {
		return fabs(each.left - line.left);
	}];;
}

-(PORKColumn *)columnForLineByCentre:(PORKLine *)line {
	return [self bestColumnForLine:line usingBlock:^CGFloat(PORKColumn *each, PORKLine *line) {
		return fabs(each.centre - line.centre);
	}];;
}

-(PORKColumn *)columnForLine:(PORKLine *)line {
	PORKColumn *best = [self columnForLineByLeftEdge:line] ?: [self columnForLineByCentre:line];
	if (!best) {
		best = [[PORKColumn alloc] initWithPage:self.page];
		[self addColumn:best];
	}
	return best;
}

-(void)addColumn:(PORKColumn *)column {
	[_columns addObject:column];
}

-(void)addLine:(PORKLine *)line {
	[[self columnForLine:line] addLine:line];
	[_columns sortUsingSelector:@selector(compare:)];
}

-(id<REDReducible>)lines {
	return REDFlattenMap(self.columns, ^id<REDReducible>(PORKColumn *column) {
		return column.lines;
	});
}

@end
