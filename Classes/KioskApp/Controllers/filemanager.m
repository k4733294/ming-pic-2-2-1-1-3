//
//  filemanager.m
//  FastPdfKit
//
//  Created by 劉 博昇 on 11/10/10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "filemanager.h"

@implementation filemanager
@synthesize filetableview;
@synthesize fileEntries,openfileEntries;
@synthesize editButton,toolbar;


-(id) initWithTabBar {
    if ([self init]) {
        //this is the label on the tab button itself
        self.title = @"filemanager";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"direction_l2r.png"];
        
        // set the long name shown in the navigation bar at the top
        self.navigationItem.title=@"filemanager";
        
        [self initWithNibName:@"filemanager" bundle:nil];
        
        
    }
    return self;
    
}

-(IBAction)actionToggleMode:(id)sender {
    
	if(status == STATUS_NORMAL) {
		
		[self enableEditing];
        
	} else if (status == STATUS_EDITING) {
		[self disableEditing];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
     NSLog(@"init");   
        fileEntries = [[NSMutableArray alloc]init];
		openfileEntries = [[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
}

-(void)enableEditing {
	
	NSMutableArray * items = [[toolbar items]mutableCopy];
    
	UIBarButtonItem * button = [items objectAtIndex:0];
	[button setTitle:@"Done"];
	
	[toolbar setItems:items];
	
    [filetableview setEditing:YES];
    status = STATUS_EDITING;
    
    
    [items release];
}
-(void)disableEditing {
    
	NSMutableArray * items = [[toolbar items]mutableCopy];
    
	UIBarButtonItem * button = [items objectAtIndex:0];
	[button setTitle:@"Edit"];
	
	[toolbar setItems:items];
	
    [filetableview setEditing:NO];
    status = STATUS_NORMAL;
    
    [items release];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {
        
        NSString * nowpath=[fileEntries objectAtIndex:indexPath.row];
        NSLog(@"now path: %@",nowpath);
        [fileEntries removeObjectAtIndex:indexPath.row];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
           NSString *documentDir = [documentPaths objectAtIndex:0];
        NSString *secondaryDirectoryPath = [documentDir stringByAppendingPathComponent:nowpath];
        NSLog(@"%@",secondaryDirectoryPath);
       [fileManager removeItemAtPath:secondaryDirectoryPath error:NULL];
        
        
        
        [self.filetableview reloadData];
        
    }    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"section");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
NSLog(@"number");
    // Return the number of rows in the section.
   return [fileEntries count];
    //return dirArray;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    NSLog(@"incellforrow");
    // Configure the cell...
    
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSArray *entry = [fileEntries objectAtIndex:indexPath.row];
	
	if(nil == cell) {
		
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
        cell.backgroundColor=[UIColor grayColor];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    
    cell.backgroundColor = [UIColor grayColor];
        [[cell imageView]setImage:[UIImage imageWithContentsOfFile:MF_BUNDLED_RESOURCE(@"FPKReaderBundle",@"img_outline_triangleright",@"png")]];
        
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    //[cell setIndentationLevel:[entry objectAtIndex:indexPath.row ]];
	
	[[cell textLabel]setText:[fileEntries objectAtIndex:indexPath.row] ];

	
   return cell;
    
}
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    MFDocumentManager * documentManager = nil;
	ReaderViewController * documentViewController = nil;
	
	NSArray *paths = nil;
	NSString *documentsDirectory = nil;
	NSString *pdfPath = nil;
	NSURL *documentUrl = nil;
    

    
    NSString * nowpath=[fileEntries objectAtIndex:indexPath.row];
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
    
	pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.pdf",nowpath,nowpath]];
    
	documentUrl = [NSURL fileURLWithPath:pdfPath];
    
    pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",nowpath]];
    
    documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
    documentManager.resourceFolder = pdfPath;
	
	documentViewController = [[ReaderViewController alloc]initWithDocumentManager:documentManager];
	documentViewController.documentId = nowpath;
	
	[[self navigationController]pushViewController:documentViewController animated:YES];
    
	[documentViewController release];
	[documentManager release];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    //self.view.backgroundColor=[UIColor blackColor];
    
     [super viewDidLoad];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
      NSLog(@"documentdir in the dir:%@",documentDir);
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    NSString *nottemp=@"temp";
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            if (file!=nottemp){
                NSLog(@" what search %@",file);
                [dirArray addObject:file];
            }
                    }
        isDir = NO;
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
    fileEntries=dirArray;
    
    //int count =[everyTitle count];
    /*for(int i=0;i<count;i++){
        NSString *file=[everyTitle objectAtIndex:i];
        NSLog(@"%@",file);
    }*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *edit =[[[UIBarButtonItem alloc]init]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionToggleMode:)];
    self.navigationItem.rightBarButtonItem=edit;
    
   
    [ self.filetableview reloadData ];
}

- (void)viewWillAppear:(BOOL)animated{
   
      [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=NO;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSLog(@"documentdir in the dir:%@",documentDir);
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    NSString *nottemp=@"temp";
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            if (file!=nottemp){
                NSLog(@" what search %@",file);
                [dirArray addObject:file];
            }
        }
        isDir = NO;
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
    fileEntries=dirArray;     
    
    [ self.filetableview reloadData ];
    
   
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(interfaceOrientation == UIDeviceOrientationPortrait){
        
		return YES;
        
	} else {
        
		return NO;
	}
}

@end
