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


-(PORKPage *)pageForLine:(PORKLine *)line {
	return self.pages[[self.document indexForPage:line.page]];
}


-(id<REDReducible>)lines {
	return REDFlattenMap(self.pages, ^id<REDReducible>(PORKPage *page) {
		return page.lines;
	});
}

-(void)addLine:(PORKLine *)line {
	[[self pageForLine:line] addLine:line];
}


+(NSSet *)dictionaryWords {
	static NSSet *dictionaryWords;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableArray *lines = [NSMutableArray new];
		
		[[NSString stringWithContentsOfFile:@"/usr/share/dict/words" encoding:NSUTF8StringEncoding error:NULL] enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
			[lines addObject:line];
		}];
		
		dictionaryWords = [NSSet setWithArray:lines];
	});
	return dictionaryWords;
}


-(NSMutableString *)dehyphenateLine:(PORKLine *)line intoString:(NSMutableString *)string {
	if ([string hasSuffix:@"-"]) {
		[string replaceCharactersInRange:(NSRange){ .location = string.length - 1, .length = 1 } withString:line.string];
	} else if (string.length) {
		[string appendString:@" "];
		[string appendString:line.string];
	} else {
		string.string = line.string;
	}
	return string;
}

l3_test(@selector(dehyphenateLine:intoString:)) {
	NSString *(^dehyphenate)(NSString *, NSString *) = ^(NSString *a, NSString *b) {
		return [[PORKDocument new] dehyphenateLine:[[PORKLine alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:b] bounds:CGRectNull] intoString:[a mutableCopy]];
	};
	l3_expect(dehyphenate(@"", @"")).to.equal(@"");
	l3_expect(dehyphenate(@"1", @"2")).to.equal(@"1 2");
	l3_expect(dehyphenate(@"hyph-", @"enate")).to.equal(@"hyphenate");
}


// fixme: attributed string
-(NSString *)string {
	return [self.lines red_reduce:[NSMutableString new] usingBlock:^(NSMutableString *into, PORKLine *line) {
		return [self dehyphenateLine:line intoString:into];
	}];
}

@end
