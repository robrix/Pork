//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Quartz/Quartz.h>

@class PORKLine;
@interface PORKPage : NSObject

-(instancetype)initWithPage:(PDFPage *)page;

@property (readonly) PDFPage *page;

@property (readonly) NSArray *columns;

@property (readonly) id<REDReducible> lines;
-(void)addLine:(PORKLine *)line;

@end
