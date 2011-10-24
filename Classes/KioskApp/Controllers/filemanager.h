//
//  filemanager.h
//  FastPdfKit
//
//  Created by 劉 博昇 on 11/10/10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MenuViewController_Kiosk.h"
#define STATUS_NORMAL 0
#define STATUS_EDITING 1

//#import "filemanagerdelegate.h"

@class DocumentViewController;

@interface filemanager : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    IBOutlet UINavigationBar * toolbar;
    IBOutlet UITableView *filetableview;
    NSUInteger status;
    NSMutableArray *fileEntries;
	NSMutableArray *openfileEntries;
    
}

-(id)initWithTabBar;
-(IBAction)actionBack:(id)sender;
-(IBAction)actionToggleMode:(id)sender;
-(IBAction)actionDone:(id)sender;
@property(nonatomic,assign)IBOutlet UITableView *filetableview;
@property (nonatomic, retain) NSArray *fileEntries;
@property (nonatomic, retain) NSArray *openfileEntries;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) IBOutlet UINavigationBar * toolbar;
//@property (nonatomic, assign) NSObject<OutlineViewControllerDelegate> *delegate;
@end
