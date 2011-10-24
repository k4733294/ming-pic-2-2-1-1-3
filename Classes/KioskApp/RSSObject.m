//
//  RSSObject.m
//
//  Created by System Administrator on 2009/2/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSObject.h"

@implementation RSSObject

@synthesize title;
@synthesize desc;
@synthesize link;

-(void) dealloc{
	[super dealloc];
	[title release];
	[desc release];
	[link release];
}
@end
