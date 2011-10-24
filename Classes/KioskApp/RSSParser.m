//
//  RSSParser.m
//
//  Created by System Administrator on 2009/2/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSParser.h"
#import "RSSObject.h"

@implementation RSSParser

// 載入從網路截取的資料
- (id) initWithData:(NSData *) data {
	self = [self init];
	NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
	rssItems = [[NSMutableArray alloc] init];
	parser.delegate = self;
	[parser parse];
	titleFound = NO;
	descFound = NO;
	itemFound = NO;
	return self;
}

// 找到某個標籤的開始
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString  *) qName attributes:(NSDictionary *) attributeDict{
	if( itemFound ){
		if( [elementName isEqualToString:@"title"] ){
			titleFound = YES;
		}
        else if( [elementName isEqualToString:@"description"] ){
			descFound = YES;
            
		}
        else if( [elementName isEqualToString:@"link"] ){
			linkFound = YES;
		}
	}
	if( [elementName isEqualToString:@"item"] ){
		itemFound = YES;		
	}
}

//  找到某個標籤的結尾
-(void) parser:(NSXMLParser *) parser didEndElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString  *) qName{
	if( [elementName isEqualToString:@"item"] ){
		itemFound = NO;
	}	
	if( itemFound ){
		if( [elementName isEqualToString:@"title"] ){
			titleFound = NO;
		}else if( [elementName isEqualToString:@"description"] ){
			descFound = NO;
		}else if( [elementName isEqualToString:@"link"] ){
			linkFound = NO;
		}
	}
}


// XML 的內文
-(void) parser:(NSXMLParser *) parser foundCharacters:(NSString *) string {
	
	if( itemFound ){
        // 將空白字元去除
		string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // 若沒有任何內容則不處理
		if( [string length]==0 ){
			return;
		}
		if( titleFound ){
			title = string;	
		}
		if( linkFound ){
			link = string;
		}
		if( descFound ){
			RSSObject *rss = [[RSSObject alloc] init];
			rss.title = title;
			rss.link = link;
			rss.desc = string;
            // 將抓取到的 rss 內容加到記憶體內
			[rssItems addObject:rss]; 
			[rss release];
		}
	}
}

// 傳回結果
-(NSMutableArray *) result
{
	return rssItems;
}

-(void) dealloc{
	[super dealloc];
	[rssItems release];
}
@end
