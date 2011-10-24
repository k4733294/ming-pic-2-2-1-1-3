//
//  RSSParser.h
//  MyMoviePlayer2
//
//  Created by MingHuei Lin on 11/9/1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



@interface RSSParser : NSObject <NSXMLParserDelegate>{
	// 標識已經找到 <item>
	BOOL itemFound;
	// 標識已經找到 <title>
	BOOL titleFound;
	// 標識已經找到 <description>
	BOOL descFound;
	// 標識已經找到 <link>
	BOOL linkFound;
	// 紀錄標題
	NSString *title;
	// 紀錄連接
	NSString *link;
	// RSS 內容 
	NSMutableArray *rssItems;
}
// 傳回結果
-(NSMutableArray *) result;
@end

