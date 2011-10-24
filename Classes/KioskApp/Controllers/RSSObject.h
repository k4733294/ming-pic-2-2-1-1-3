//
//  RSSObject.h
//
//  Created by System Administrator on 2009/2/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface RSSObject : NSObject {
	// <title>
	NSString *title;
	// <description>
	NSString *desc;
	// <link>
	NSString *link;
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,retain) NSString *link;

@end
