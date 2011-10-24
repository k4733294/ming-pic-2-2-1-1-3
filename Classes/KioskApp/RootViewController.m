//
//  RootViewController.m
//  MyMoviePlayer2
//
//  Created by Eric Lin on 2010/7/13.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"


@implementation RootViewController

@synthesize detailViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	self.title = @"我的 MTV";
	
    /*
    movies = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
			  @"http://192.168.1.8/~eric/Sorry,Sorry.mp4",@"Sorry,Sorry",
			  @"http://192.168.1.8/~eric/Nobody.mp4",@"Nobody",
			  nil];
	movieNames = [[NSArray alloc] initWithArray:[movies allKeys]];
   
    */
   
	// 抓取資料
    
	NSURL *url = [[[NSURL alloc] initWithString:@"http://192.192.155.89/upload/shu2.xml"] autorelease];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
    parser = [[RSSParser alloc] initWithData:data];
	movieNames = [parser result];


     
}



/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if( interfaceOrientation==UIInterfaceOrientationLandscapeLeft )
		return YES;
	else
		return NO;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [movieNames count];
    //return [movieNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)

indexPath {
    
	
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	// 自記憶體內容取出
    NSInteger row = [indexPath row];
	RSSObject *rss = [movieNames objectAtIndex:row];
	cell.textLabel.text = rss.title;

    return cell;


/*
    indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if( movieNames!=nil ){
		cell.textLabel.text = [movieNames objectAtIndex:[indexPath row]];
	}
    return cell;
 
 */
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

// 選取影片後播放
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = [indexPath row];
	//RSSObject *rss = [rssContent objectAtIndex:row];
    RSSObject *rss = [movieNames objectAtIndex:row];
 
	//NSStream *qwe = rss.link;
 
    NSLog(@"%@",rss.link);
    

 
    
    //NSURL *url = [[NSURL alloc]initWithString:[movies objectForKey:[movieNames objectAtIndex:[indexPath row]]]];
    
    //NSURL *url = [[NSURL alloc]initWithString:[movies objectForKey:@"http://192.168.1.8/~eric/Sorry,Sorry.mp4"]];
    
    //NSURL *url = [[NSURL alloc]initWithString:@"http://192.192.155.89/upload/ACE%20COMBAT%20ASSAULT%20HORIZON%20GAMESCOM%202011%20TRAILER_(720p).mp4"];
    
   // NSURL *url = [[NSURL alloc]initWithString:@"http://192.192.155.89/upload/ACE%20COMBAT%20ASSAULT%20HORIZON%20GAMESCOM%202011%20TRAILER_(720p).mp4"];
    
     NSURL *url = [[NSURL alloc]initWithString:rss.link ];
    
    //NSLog(@"%@",url);
    
   
	if( playerController==nil ){
		playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];	
         //NSLog(@"%@",url);
		playerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+50);
		playerController.view.autoresizesSubviews = YES;
		playerController.fullscreen = YES;
		playerController.scalingMode=MPMovieScalingModeAspectFill|MPMovieScalingModeAspectFit;
		
		detailViewController.view=playerController.view;
		[[NSNotificationCenter defaultCenter] addObserver:self 
										      selector:@selector(resumeViewSize:) 
											  name:MPMoviePlayerWillExitFullscreenNotification 
										      object:playerController];
	}else {
     
	[playerController setContentURL:url];
	}
 	[playerController play]; 
	[url release];	
}

// 偵測播放畫面是否恢復原來大小
- (void)resumeViewSize:(NSNotification*)aNotification
{
	NSLog(@"Resized!");
} 
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
										  name:MPMoviePlayerWillExitFullscreenNotification
										  object:playerController];
    [detailViewController release];
    [super dealloc];
	[movieNames release];
	[movies release];
	[playerController release];
}


@end

