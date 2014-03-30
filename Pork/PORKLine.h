//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Quartz/Quartz.h>

@interface PORKLine : NSObject

-(instancetype)initWithAttributedString:(NSAttributedString *)attributedString bounds:(CGRect)bounds;
-(instancetype)initWithSelection:(PDFSelection *)selection;

@property (readonly) PDFPage *page;
@property (readonly) PDFSelection *selection;

@property (readonly) NSString *string;
@property (readonly) NSAttributedString *attributedString;

@property (readonly) CGRect bounds;
@property (readonly) CGFloat left;
@property (readonly) CGFloat centre;

-(NSComparisonResult)compare:(PORKLine *)other;

@end
