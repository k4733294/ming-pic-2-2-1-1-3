//
//  filemanagerDelegate.h
//  FastPdfKit
//
//  Created by 劉 博昇 on 11/10/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface filemanagerDelegate : NSObject <UIApplicationDelegate>{
    UIWindow* window;
    UINavigationController *navController;
    
}

@property(nonatomic,retain)IBOutlet UIWindow * window;


@end