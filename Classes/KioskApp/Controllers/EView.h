//
//  EView.h
//  Ming
//
//  Created by YaHung Kuo on 11/9/22.
//  Copyright 2011年 SHU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EView : UIViewController
{
    IBOutlet UIWebView *myWevView;
    IBOutlet UITextField *accoutName;   
    IBOutlet UITextField *accoutPassword;  
    UIAlertView *myAlertView;
}
@property (nonatomic,retain) UIWebView *myWevView;
@property (nonatomic,retain) UIAlertView *myAlertView;

-(IBAction) Login:(id)sender;

@end
