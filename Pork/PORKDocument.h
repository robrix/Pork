//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Quartz/Quartz.h>

@interface PORKDocument : NSObject

-(instancetype)initWithDocument:(PDFDocument *)document;

@property (readonly) PDFDocument *document;

@property (readonly) NSArray *pages;

@property (readonly) id<REDReducible> lines;

@end
