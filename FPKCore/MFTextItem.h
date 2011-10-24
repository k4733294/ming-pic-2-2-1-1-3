//
//  MFSearchItem.h
//  FastPDFKitTest
//
//  Created by Nicolò Tosi on 10/25/10.
//  Copyright 2010 MobFarm S.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MFOverlayDrawable.h"

@interface MFTextItem : NSObject<MFOverlayDrawable> {

	@private
	NSString *text;
	CGPathRef highlightPath;
	NSUInteger page;
	NSRange searchTermRange;
}

/**
 Default initializer. Init the Text Item with some text and a path for the hilight that will be rendered in
 page space.
 */
-(id)initWithText:(NSString *)someText andHighlightPath:(CGPathRef)aPath;

/**
 Default initializer, plus the page number.
 */
-(id)initWithText:(NSString *)someText highlightPath:(CGPathRef)aPath andPage:(NSUInteger)aPage;

@property (nonatomic,readwrite) NSRange searchTermRange;

/**
 Some text to be displayed along with the item.
 */
@property (readonly) NSString *text;

/**
 The path for the hilight. It is defined in page space.
 */
@property (readonly) CGPathRef highlightPath;

/**
 The page of which this text item represent the position of a word.
 */
@property (readonly) NSUInteger page;

@end
