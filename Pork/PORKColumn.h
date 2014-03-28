//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Quartz/Quartz.h>

@class PORKLine;
@interface PORKColumn : NSObject

-(instancetype)initWithPage:(PDFPage *)page;

@property (readonly) PDFPage *page;

@property (readonly) NSString *string;

@property (readonly) NSRect bounds;
@property (readonly) CGFloat left;
@property (readonly) CGFloat centre; // centre along x

@property (readonly) NSArray *lines;
-(void)addLine:(PORKLine *)line;

-(NSComparisonResult)compare:(PORKColumn *)other;

@end
