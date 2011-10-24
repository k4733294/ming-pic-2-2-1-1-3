//
//  RootViewController.h
//  MyMoviePlayer2
//
//  Created by Eric Lin on 2010/7/13.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RSSParser.h"
#import "RSSObject.h"
@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	NSMutableDictionary *movies;
	NSArray *movieNames;
	MPMoviePlayerController *playerController;	
    
    
    RSSParser *parser;
    NSMutableArray *rssContent;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
