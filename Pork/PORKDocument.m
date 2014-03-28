//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "PORKDocument.h"
#import "PORKPage.h"
#import "PORKLine.h"

@implementation PORKDocument {
	NSMutableArray *_pages;
}

-(instancetype)initWithDocument:(PDFDocument *)document {
	if ((self = [super init])) {
		_document = document;
		_pages = [NSMutableArray new];
		for (NSUInteger i = 0; i < document.pageCount; i++) {
			[_pages addObject:[[PORKPage alloc] initWithPage:[document pageAtIndex:i]]];
		}
		
		for (PDFSelection *selection in document.selectionForEntireDocument.selectionsByLine) {
			[self addLine:[[PORKLine alloc] initWithSelection:selection]];
		}
	}
	return self;
}


-(id<REDReducible>)lines {
	return REDFlattenMap(self.pages, ^id<REDReducible>(PORKPage *page) {
		return page.lines;
	});
}

-(void)addLine:(PORKLine *)line {
	[[self pageForLine:line] addLine:line];
}


-(PORKPage *)pageForLine:(PORKLine *)line {
	return self.pages[[self.document indexForPage:line.page]];
}

@end
