//
//  MyMoviePlayer2AppDelegate.m
//  MyMoviePlayer2
//
//  Created by Eric Lin on 2010/7/13.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//  註解再這邊 by郭亞宏 20111021
//

#import "MyMoviePlayer2AppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"
#import "MenuViewController_Kiosk.h"
#import "EView.h"
#import "filemanager.h"

@implementation MyMoviePlayer2AppDelegate


@synthesize window, splitViewController, rootViewController, detailViewController,navigationController,TabBarcontroller;


#pragma mark -
#pragma mark Application lifecycle


-(IBAction)pp:(id)sender
    {
        [window addSubview:splitViewController.view];
        [UIView beginAnimations:@"animationID" context:nil]; 
        [UIView setAnimationDuration:2.5]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
        [UIView setAnimationRepeatAutoreverses:NO]; 
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:YES];
        [window exchangeSubviewAtIndex:1 withSubviewAtIndex:0]; 
        [UIView commitAnimations];
        
    }   

-(IBAction)erro:(id)sender
{
    NSUserDefaults *userpassword;
    userpassword = [NSUserDefaults standardUserDefaults];
    [userpassword setObject:nil forKey:@"userpass"];
    [userpassword setObject:nil forKey:@"username"];
    [userpassword synchronize];     
    NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
     

    MenuViewController_Kiosk *aMenuViewController = nil;
    aMenuViewController = [[MenuViewController_Kiosk alloc]initWithNibName:@"Kiosk_ipad" bundle:MF_BUNDLED_BUNDLE(@"FPKKioskBundle")];
    
    
	UINavigationController *aNavController = [[UINavigationController alloc]initWithRootViewController:aMenuViewController];
	[aNavController setNavigationBarHidden:YES];
	[self setNavigationController:aNavController];
	
	[window addSubview:[aNavController view]];
    [window makeKeyAndVisible];
	
	// Cleanup
	
	[aNavController release];
	[aMenuViewController release];
    
    
}
-(IBAction)iii:(id)sender
{
   TabBarcontroller = [[UITabBarController alloc] init];
    
    NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:2];
    //====================================   
    filemanager *fm=nil;
    fm = [[filemanager alloc]initWithTabBar];
    
    
    MenuViewController_Kiosk *menu = nil;
    menu = [[MenuViewController_Kiosk alloc]initWithTabBar];
    
    
    UINavigationController *localNavigationController;
    
    localNavigationController = [[UINavigationController alloc] initWithRootViewController:menu];
    [localControllersArray addObject:localNavigationController];
    
    //====================================
    
    
    
    localNavigationController = [[UINavigationController alloc]initWithRootViewController:fm];
    [localControllersArray addObject:localNavigationController];
    
    
    TabBarcontroller.viewControllers = localControllersArray;
    
    
    [window addSubview:TabBarcontroller.view];
    [window makeKeyAndVisible];
    
    [localNavigationController release];
   // [fm release];
    [localNavigationController release];
    [menu release];
    [localControllersArray release];
    /*
    MenuViewController_Kiosk *aMenuViewController = nil;
    aMenuViewController = [[MenuViewController_Kiosk alloc]initWithNibName:@"Kiosk_ipad" bundle:MF_BUNDLED_BUNDLE(@"FPKKioskBundle")];
    
    
	UINavigationController *aNavController = [[UINavigationController alloc]initWithRootViewController:aMenuViewController];
	[aNavController setNavigationBarHidden:YES];
	[self setNavigationController:aNavController];*/
    
    [UIView beginAnimations:@"animationID" context:nil]; 
    [UIView setAnimationDuration:1.5]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
    [UIView setAnimationRepeatAutoreverses:NO]; 
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
    [window exchangeSubviewAtIndex:1 withSubviewAtIndex:0]; 
    [UIView commitAnimations];
    
	
	//[window addSubview:[aNavController view]];
    [window makeKeyAndVisible];
	
	// Cleanup
	
	//[aNavController release];
	//[aMenuViewController release];
      
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
       // Override point for customization after app launch.
    
    // Add the split view controller's view to the window and display.
    //[window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"]; 
    NSLog(@"%@",pass);
    NSLog(@"%@",name);
    return YES;
}


- (void)viewDidLoad
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [splitViewController release];
    [view release];
    [super dealloc];
}


@end

