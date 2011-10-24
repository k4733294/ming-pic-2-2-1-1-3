//
//  EView.m
//  Ming
//
//  Created by YaHung Kuo on 11/9/22.
//  Copyright 2011年 SHU. All rights reserved.
//

#import "EView.h"

@implementation EView
@synthesize myWevView;
@synthesize myAlertView;


-(IBAction)Login:(id)sender
{
    myAlertView= [[UIAlertView alloc] initWithTitle:@"系統登入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入",nil];
    
    [myAlertView show];
    [myAlertView release];
}


- (void)willPresentAlertView:(UIAlertView *)alertView
{
	CGRect frame = alertView.frame;
	if( alertView==myAlertView )
	{
		frame.origin.y -= 120;
		frame.size.height += 80;
		alertView.frame = frame;
		for( UIView * view in alertView.subviews )
		{
            //列舉alertView中所有的物件
			if( ![view isKindOfClass:[UILabel class]] )
			{
                //若不UILable則另行處理
                if (view.tag==1)
                {
                    //處理第一個按鈕，也就是 CancelButton
                   	CGRect btnFrame1 =CGRectMake(30, frame.size.height-65, 105, 40);
                    view.frame = btnFrame1;
                    
                } else if  (view.tag==2){
                    //處理第二個按鈕，也就是otherButton    
                    CGRect btnFrame2 =CGRectMake(142, frame.size.height-65, 105, 40);
                    view.frame = btnFrame2;
                    
                }
			}
		}
		
        //加入自訂的label及UITextFiled
        UILabel *lblaccountName=[[UILabel alloc] initWithFrame:CGRectMake( 30, 50,60, 30 )];;
        lblaccountName.text=@"帳號：";
        lblaccountName.backgroundColor=[UIColor clearColor];
        lblaccountName.textColor=[UIColor whiteColor];
        
        
        
        accoutName = [[UITextField alloc] initWithFrame: CGRectMake( 85, 50,160, 30 )];   
        accoutName.placeholder = @"帳號名稱";
        accoutName.borderStyle=UITextBorderStyleRoundedRect;
        
        
        UILabel *lblaccountPassword=[[UILabel alloc] initWithFrame:CGRectMake( 30, 85,60, 30 )];;
        lblaccountPassword.text=@"密碼：";
        lblaccountPassword.backgroundColor=[UIColor clearColor];
        lblaccountPassword.textColor=[UIColor whiteColor];
        
        accoutPassword = [[UITextField alloc] initWithFrame: CGRectMake( 85, 85,160, 30 )];   
        accoutPassword.placeholder = @"登入密碼";
        accoutPassword.borderStyle=UITextBorderStyleRoundedRect;
        //輸入的資料以星號顯示（密碼資料）
        accoutPassword.secureTextEntry=YES;
        
     	[alertView addSubview:lblaccountName];
		[alertView addSubview:accoutName];         
        [alertView addSubview:lblaccountPassword];
		[alertView addSubview:accoutPassword];
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * ttxt;
    //   NSString * accoutPassword;
    ttxt = @"asd";
    NSLog(@"%@",accoutName.text);
	if (buttonIndex == 0) {
        // ccountName = (TextFieldIndex == 0).text;
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var field = document.getElementById('username');" 
                                                           "field.value='%@'", accoutName.text]];
    }
    else if (buttonIndex == 1) {
        
        
        
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@'", accoutName.text]];
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@'", accoutPassword.text]];
        [myWevView stringByEvaluatingJavaScriptFromString:@"var field3 = document.getElementsByTagName('button')[0];"
         "field3.click();"];
        
    }
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
     [myWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
