//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Quartz/Quartz.h>
#import <Reducers/Reducers.h>
#import "PORKAppDelegate.h"
#import "PORKDocument.h"
#import "PORKLine.h"

@interface PORKAppDelegate ()

@property IBOutlet PDFView *PDFView;
@property IBOutlet NSTextView *textView;
@property PORKDocument *openedDocument;

@end

@implementation PORKAppDelegate

-(IBAction)openDocument:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	openPanel.allowedFileTypes = @[ @"pdf" ];
	if ([openPanel runModal] == NSOKButton) {
		self.openedDocument = [[PORKDocument alloc] initWithDocument:self.PDFView.document = [[PDFDocument alloc] initWithURL:openPanel.URLs.firstObject]];
		
		[self.textView.textStorage replaceCharactersInRange:(NSRange){ .length = self.textView.textStorage.length } withString:self.openedDocument.string];
	}
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
	[self openDocument:nil];
}

@end
