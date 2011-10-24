//
//  MenuViewController_Kiosk.m
//  FastPdfKit Sample
//
//  Created by Gianluca Orsini on 28/02/11.
//  Copyright 2010 MobFarm S.r.l. All rights reserved.
//

#import "MenuViewController_Kiosk.h"
#import "MFDocumentManager.h"
#import "ReaderViewController.h"
#import "MFHomeListPdf.h"
#import "filemanager.h"
#import "XMLParser.h"
#include <stdio.h>
#include <stdlib.h>

//#define FPK_KIOSK_XML_URL @"http://go.mobfarm.eu/pdf/kiosk_list.xml"

#define FPK_KIOSK_XML_URL @"http://www.google.com/search?hl=zh-TW&client=safari&rls=en&biw=1278&bih=642&q=pdf&oq=pdf&aq=f&aqi=&aql=&gs_sm=e&gs_upl=35534l35534l0l35731l1l1l0l0l0l0l0l0ll0l0"

#define FPK_KIOSK_XML_NAME @"kiosk_list"

@implementation MenuViewController_Kiosk

@synthesize buttonRemoveDict;
@synthesize openButtons;
@synthesize progressViewDict,imgDict;
@synthesize documentsList;
@synthesize graphicsMode;
//----------------------------------------
@synthesize documents,currentItem;
//----------------------------------------

@synthesize myWevView;
@synthesize myWevView2;
@synthesize myAlertView;
@synthesize pdfUrl;
MFHomeListPdf * viewPdf = nil;
UIScrollView * aScrollView = nil;
-(id) initWithTabBar {
    if ([self init]) {
        //this is the label on the tab button itself
        self.title = @"elearn";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"bookmark_add_phone.png"];
        // set the long name shown in the navigation bar at the top
        self.navigationItem.title=@"mobilelearn";
        
        [self initWithNibName:@"Kiosk_ipad" bundle:MF_BUNDLED_BUNDLE(@"FPKKioskBundle")];
        
        
    }
    return self;
    
}


-(IBAction) Logout:(id)sender
{
    //clean cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }

    //[NSURLCache sharedURLCache] removeAllCachedResponses];    
    NSUserDefaults *userpassword;
    userpassword = [NSUserDefaults standardUserDefaults];
    [userpassword setObject:nil forKey:@"userpass"];
    [userpassword setObject:nil forKey:@"username"];
    [userpassword synchronize];     
    NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    [myWevView reload];
    
    [myWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw"]]];
    [[[myWevView subviews] lastObject]setScrollEnabled:NO];
    myWevView.hidden=YES;
    
    myAlertView= [[UIAlertView alloc] initWithTitle:@"系統登入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入",nil];    
    

}
-(void)GoToPdf
{
    [UIView beginAnimations:@"animationID" context:nil]; 
    [UIView setAnimationDuration:1.5]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
    [UIView setAnimationRepeatAutoreverses:NO]; 
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:aScrollView cache:YES];
    [aScrollView exchangeSubviewAtIndex:1 withSubviewAtIndex:0]; 
    [UIView commitAnimations];
    
 // Used to iterate over each item in the list.
   
    if(aScrollView != nil)
    {
    [aScrollView removeFromSuperview];
    }
    
    XMLParser *parser = nil;
    NSURL * xmlUrl = nil;
    
    //UIScrollView * aScrollView = nil;
    CGFloat yBorder = 0 ; 
    UIImageView * anImageView = nil;
    
    CGRect frame;
    NSString * titoloPdf = nil;
    NSString * Pdftitle = nil;
    NSString * titoloPdfNoSpace = nil;
    NSString * linkPdf = nil;
    NSString * copertinaPdf = nil;
    
    
    //MFHomeListPdf * viewPdf = nil;
    
    int documentsCount;
    
	//Graphics visualization
    CGFloat thumbWidth;
	CGFloat thumbHeight;
	CGFloat scrollViewWidth;
	CGFloat scrollViewHeight;
	CGFloat detailViewHeight;
	CGFloat thumbHOffsetLeft;
	CGFloat thumHOffsetRight;
	CGFloat frameHeight;
	CGFloat scrollViewVOffset;
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
        
		thumbWidth = 350.0;
		thumbHeight = 480.0;
		thumbHOffsetLeft = 20.0;
		thumHOffsetRight = 380.0;
		frameHeight = 275.0;
		scrollViewWidth = 771.0;
		scrollViewHeight = 975.0;
		detailViewHeight = 765.0;
		scrollViewVOffset = 80.0;
		
	} else {
		
		thumbWidth = 125.0;
		thumbHeight = 170.0;
		thumbHOffsetLeft = 10.0;
		thumHOffsetRight = 160.0;
		frameHeight = 115.0;
		scrollViewWidth = 323.0;
		scrollViewHeight = 404.0;
		detailViewHeight = 240.0;
		scrollViewVOffset = 80.0;
	}
	
    
    
    
    
	
	parser = [[XMLParser alloc] init];
	xmlUrl = [NSURL URLWithString:FPK_KIOSK_XML_URL];
    [parser parseXMLFileAtURL:xmlUrl];
	
    // Try to parse the remote URL. If it fails, fallback to the local xml.
    
    if([parser isDone]) {
        
        self.documentsList = [parser parsedItems];    
        
    } else {
        
        xmlUrl = [MF_BUNDLED_BUNDLE(@"FPKKioskBundle") URLForResource:FPK_KIOSK_XML_NAME withExtension:@"xml"];
        [parser parseXMLFileAtURL:xmlUrl];
        
        if([parser isDone]) {
            self.documentsList = [parser parsedItems];
        }
    }
	
	[parser release];
	
	//---------------------------------------------
    //----------底下原是運算從xml得到的資料做迴圈一個個從陣列讀出 部分語法往上改-------
   
    
    
	documentsCount = pdfCounter;  
    
    
    
    
    
	//產生檔案與檔案間的圖形編排方式  先禁止移除！！！！！做測試------------
	aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(325, scrollViewVOffset, scrollViewWidth, scrollViewHeight)];
    aScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"done.png"]];
	
	aScrollView.contentSize = CGSizeMake(scrollViewWidth, detailViewHeight * ((documentsCount/2)+(documentsCount%2)));
	//-----------------------------
    //----------底下原是運算從xml得到的資料做迴圈一個個從陣列讀出 部分語法往下改-------
    
	//for (int i=1; i<= documentsCount ; i++) {
    
	//	titoloPdf = [[documentsList objectAtIndex: i-1] objectForKey: @"title"];
    //    titoloPdfNoSpace = [titoloPdf stringByReplacingOccurrencesOfString:@" " withString:@""];
	//	linkPdf = [[documentsList objectAtIndex: i-1] objectForKey: @"link"];
	//	copertinaPdf = [[documentsList objectAtIndex: i-1] objectForKey: @"cover"];
    
    //----------------documentlist格式自定的位置 
    //---我改的部份    抓出重點欄位先把直改上去
    //                其他還有許多檔案相依的關係 需要修正 需要細談
    //----------------------------------------------------------------
    
    // NSMutableArray * documentsArray = [[NSMutableArray alloc] init];
    // self.documents = documentsArray;
    // [documentsArray release];
    
    // NSMutableDictionary * dictionary = nil;
    //dictionary = [[NSMutableDictionary alloc] init];
    //self.currentItem = dictionary;
    
    
   // linkPdf =pdfUrl;
    
    
    
    // titoloPdf＝@"45612jkljkl3151656";
    titoloPdf =[NSString stringWithFormat:@"Java.How.to.Program,7th.Edition"];
    
    
    
    NSLog(@"%@",titoloPdf);
    titoloPdfNoSpace = [titoloPdf stringByReplacingOccurrencesOfString:@" " withString:@""]; 
    
    
    //-------------------------------------------------------------------
    
    //  先假設迴圈產生menu的檔案列表
    
    
	for (int i=1; i<= documentsCount ; i++) {
		//這邊有動過手腳 還要給對面是地幾個檔案 numdoc現設為10
        /*
         titoloPdf = [[documentsList objectAtIndex: i-1] objectForKey: @"title"];
         titoloPdfNoSpace = [titoloPdf stringByReplacingOccurrencesOfString:@" " withString:@""];
         linkPdf = [[documentsList objectAtIndex: i-1] objectForKey: @"link"];
         copertinaPdf = [[documentsList objectAtIndex: i-1] objectForKey: @"cover"];
         */
        titoloPdf = [pdfTitle objectAtIndex: i-1];
        titoloPdfNoSpace = [titoloPdf stringByReplacingOccurrencesOfString:@" " withString:@""];
        linkPdf = [pdfUrl objectAtIndex: i-1];
        NSLog(@"url:%@",linkPdf);
        viewPdf = [[MFHomeListPdf alloc] initWithName:titoloPdfNoSpace andTitoloPdf:titoloPdf andLinkPdf:linkPdf andnumOfDoc:i andImage:copertinaPdf andSize:CGSizeMake(thumbWidth, thumbHeight)];
        
		frame = self.view.frame;
		
		if ((i%1)==0) {
			/*frame.origin.y = (frameHeight * 2 ) * ( (i-1) / 2 );
			frame.origin.x = thumHOffsetRight;
			frame.size.width = thumbWidth;
			frame.size.height = detailViewHeight;
		}else {*/
			frame.origin.y = frameHeight *(i-1);
			frame.origin.x = thumbHOffsetLeft;
			frame.size.width = thumbWidth;
			frame.size.height = detailViewHeight;
		} 

		
		viewPdf.view.frame = frame;
		viewPdf.menuViewController = self;
		[aScrollView addSubview:viewPdf.view];
		
		// Adding stuff to their respective containers.
		
		[imgDict setValue:viewPdf.openButtonFromImage forKey:titoloPdfNoSpace];
		[openButtons setValue:viewPdf.openButton forKey:titoloPdfNoSpace];
		[buttonRemoveDict setValue:viewPdf.removeButton forKey:titoloPdfNoSpace];
		[progressViewDict setValue:viewPdf.progressDownload forKey:titoloPdfNoSpace];
		
		[homeListPdfs addObject:viewPdf];
		[viewPdf release];
		
	}
	
	[self.view addSubview:aScrollView];
	// self.scrollView = aScrollView; // Not referenced anywhere else.
	[aScrollView release];
	
	// Border.
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		yBorder = scrollViewVOffset-3 ;
	}else {
		yBorder = scrollViewVOffset-1 ;
	}
	
	anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yBorder, scrollViewWidth, 40)]; 
	//[anImageView setImage:[UIImage imageWithContentsOfFile:MF_BUNDLED_RESOURCE(@"FPKKioskBundle",@"border",@"png")]];
	[self.view addSubview:anImageView];
	[anImageView release];
    
}
////-----------GoToPdf---End------------------//////
////-----------PdfButton----------------------

-(void)getHtml{
    
    NSString *asd = @"asd";
    NSString * fileUrl;
    pdfUrl = [[NSMutableArray alloc]init];
    pdfTitle = [[NSMutableArray alloc]init];
    
    asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[1].id"];
    
    
    if(![asd isEqualToString:@"toGo"])
    {
        //NSMutableArray * arr=[[NSMutableArray alloc]init];
        NSString *testTitle;
        pdfCounter = 1;
        fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[1].href"];
        testTitle =  [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a')[2].text"];
        
        [pdfTitle addObject:testTitle];
        [pdfUrl addObject:fileUrl];
        
        
        asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[3].id"];
        if(![asd isEqualToString:@"toGo"])
        {
            pdfCounter++;
            
            fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[3].href"];

            testTitle =  [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a')[4].text"];
            
            [pdfTitle addObject:testTitle];
            [pdfUrl addObject:fileUrl];
            
            asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[5].id"] ;
            if(![asd isEqualToString:@"toGo"])
            {
                pdfCounter++;
                
                fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[5].href"];
                testTitle =  [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a')[6].text"];
                
                [pdfTitle addObject:testTitle];
                [pdfUrl addObject:fileUrl];
                
                asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[7].id"];
                if(![asd isEqualToString:@"toGo"])
                {
                    pdfCounter++;
                    fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[7].href"];
                    testTitle =  [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a')[8].text"];
                    
                    [pdfTitle addObject:testTitle];
                    [pdfUrl addObject:fileUrl];
                }
            }
        }
        
    }
    // [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:asd]]];
    myWevView2.hidden=YES;
    [self GoToPdf];
    
    
}

-(void)PdfButton:(id)i
{
   	
}
////-----------EndPdfButton-------------------

-(IBAction)week:(id)sender
{
    switch ([sender tag]) {
        case 1:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?1"]]];
            
            break;
        case 2:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?2"]]];
            
            break;
        case 3:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?3"]]];
            break;
        case 4:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?4"]]];
            break;
        case 5:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?5"]]];
            break;
        case 6:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?6"]]];
            break;
        case 7:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?7"]]];
            break;
        case 8:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?8"]]];
            break;
        case 9:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?9"]]];
            break;
        case 10:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?10"]]];
            break;
        case 11:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?11"]]];
            break;
        case 12:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?12"]]];
            break;
        case 13:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?13"]]];
            break;
        case 14:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?14"]]];
            break;
        case 15:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?15"]]];
            break;
        case 16:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?16"]]];
            break;
        case 17:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?17"]]];
            break;
        case 18:
            [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw/learn/file_list.php?18"]]];
            break;
    }
    
    pdfUrl = nil;
    pdfTitle = nil;
}

-(IBAction)fileNumber:(id)sender{
    
            
    NSString *asd = @"asd";
    NSString * fileUrl;
    pdfUrl = [[NSMutableArray alloc]init];
    
    asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[1].id"];

    
    if(![asd isEqualToString:@"toGo"])
    {
        //NSMutableArray * arr=[[NSMutableArray alloc]init];
        NSString *testTitle;
        pdfCounter = 1;
        fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[1].href"];
        testTitle =  [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a')[2].target"];
        NSLog(@"title1:%@",testTitle);
        testTitle =  [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a')[1]"];
        NSLog(@"title2:%@",testTitle);
        
        [pdfUrl addObject:fileUrl];
       
        
        asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[3].id"];
        if(![asd isEqualToString:@"toGo"])
        {
            pdfCounter++;
            
            fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[3].href"];
            
            [pdfUrl addObject:fileUrl];
            
            asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[5].id"] ;
            if(![asd isEqualToString:@"toGo"])
            {
                pdfCounter++;
                
                fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[5].href"];
                [pdfUrl addObject:fileUrl];
                
                asd =[myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[7].id"];
                if(![asd isEqualToString:@"toGo"])
                {
                    pdfCounter++;
                    fileUrl = [myWevView2 stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"a\")[7].href"];
                    [pdfUrl addObject:fileUrl];
                }
            }
        }
            
    }
        // [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:asd]]];
   // myWevView2.hidden=NO;
    [self GoToPdf];
    
    
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
        
        NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
        NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];         
        accoutName = [[UITextField alloc] initWithFrame: CGRectMake( 85, 50,160, 30 )];   
        accoutName.placeholder =@"輸入帳號";
        accoutName.borderStyle=UITextBorderStyleRoundedRect;
        
        
        UILabel *lblaccountPassword=[[UILabel alloc] initWithFrame:CGRectMake( 30, 85,60, 30 )];;
        lblaccountPassword.text=@"密碼：";
        lblaccountPassword.backgroundColor=[UIColor clearColor];
        lblaccountPassword.textColor=[UIColor whiteColor];
        
        accoutPassword = [[UITextField alloc] initWithFrame: CGRectMake( 85, 85,160, 30 )];   
        accoutPassword.placeholder=@"輸入密碼";
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
    //NSString * ttxt;
    //   NSString * accoutPassword;
    //ttxt = @"asd";
    //NSLog(@"%@",accoutName.text);
    /*NSUserDefaults *userpassword;
    userpassword = [NSUserDefaults standardUserDefaults];
    [userpassword setObject:accoutPassword.text forKey:@"userpass"];
    [userpassword setObject:accoutName.text forKey:@"username"];
    [userpassword synchronize];
     */
    
    NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];   
    //NSLog(@"%@",pass);
    //NSLog(@"%@",name); 	
    if (buttonIndex == 0) {
        // ccountName = (TextFieldIndex == 0).text;
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var field = document.getElementById('username');" 
                                                           "field.value='%@'", accoutName.text]];
    }
    else if (buttonIndex == 1) {
        
        /*[myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@'", accoutName.text]];
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@'", accoutPassword.text]];
        [myWevView stringByEvaluatingJavaScriptFromString:@"var field3 = document.getElementsByTagName('button')[0];"
         "field3.click();"];  
         */
        
        NSLog(@"login");
        
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@'", accoutName.text]];
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@'", accoutPassword.text]];
        [myWevView stringByEvaluatingJavaScriptFromString:@"var field3 = document.getElementsByTagName('button')[0];"
         "field3.click();"];
        myWevView.hidden=NO;
            NSUserDefaults *userpassword;
            userpassword = [NSUserDefaults standardUserDefaults];
            [userpassword setObject:accoutPassword.text forKey:@"userpass"];
            [userpassword setObject:accoutName.text forKey:@"username"];
            [userpassword synchronize];           
        
        
        //NSLog(@"%@",accoutName);
        //NSLog(@"%@",accoutPassword);
        /*NSUserDefaults *userpassword;
        userpassword = [NSUserDefaults standardUserDefaults];
        [userpassword setObject:accoutPassword.text forKey:@"userpass"];
        [userpassword setObject:accoutName.text forKey:@"username"];
        [userpassword synchronize];
            
        NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
        NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];   
        NSLog(@"%@",pass);
        NSLog(@"%@",name); 
         */      
       /* else{
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@'", name]];
        [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@'", pass]];
        [myWevView stringByEvaluatingJavaScriptFromString:@"var field3 = document.getElementsByTagName('button')[0];"
         "field3.click();"];
            //NSLog(@"%@",pass);
            //NSLog(@"%@",name);         
            
        }*/
    }
    
    
}



////-----------------------------------//////


-(IBAction)actionOpenPlainDocument:(NSString *)documentName {
	
	MFDocumentManager * documentManager = nil;
	ReaderViewController * documentViewController = nil;
	
	NSArray *paths = nil;
	NSString *documentsDirectory = nil;
	NSString *pdfPath = nil;
	NSURL *documentUrl = nil;
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.pdf",documentName,documentName]];
	documentUrl = [NSURL fileURLWithPath:pdfPath];
    
    pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];
	//pdfPath = @"http://www.google.com/url?sa=t&source=web&cd=7&ved=0CFwQFjAG&url=http%3A%2F%2Fwww.cto.moea.gov.tw%2F04%2Fregister%2Fregister.pdf&ei=mGyBTpzyFsvnmAWwmIk_&usg=AFQjCNEgxpV4FPei2hHBUQ_oU5ugfUwkZA";
	
	
	// Now that we have the URL, we can allocate an istance of the MFDocumentManager class and use
	// it to initialize an MFDocumentViewController subclass 	
	
	documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
    documentManager.resourceFolder = pdfPath;
	
	documentViewController = [[ReaderViewController alloc]initWithDocumentManager:documentManager];
	documentViewController.documentId = documentName;
	
	[[self navigationController]pushViewController:documentViewController animated:YES];
    
	[documentViewController release];
	[documentManager release];
	
	
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		buttonRemoveDict = [[NSMutableDictionary alloc] init];
		openButtons = [[NSMutableDictionary alloc] init];
		progressViewDict = [[NSMutableDictionary alloc] init];
		imgDict = [[NSMutableDictionary alloc] init];
		
		homeListPdfs = [[NSMutableArray alloc]init];
		
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"start load");  
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}


- (void)viewDidLoad {
    
    
       self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_background_wood-wallpaper-768x1024.jpg"]];
    [myWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw"]]];
    [myWevView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw"]]];
    
    myWevView.hidden=YES;
    myWevView2.hidden=YES;    

    [[[myWevView subviews] lastObject]setScrollEnabled:NO];
    //-----------File setting-----------------------------
   
    
    //------------Button Setting---------------------------
    
    
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnOne.frame = CGRectMake(40, 100, 200, 40);
    UIImage *btnImage = [UIImage imageNamed:@"NB2.png"];
    btnOne.backgroundColor=[UIColor clearColor];
    [btnOne setTag:1];
    [btnOne setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnOne setTitle:@"week1" forState:UIControlStateNormal];
    [btnOne setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnOne addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnOne];
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnTwo.frame = CGRectMake(40, 145, 200, 40);
    btnTwo.backgroundColor=[UIColor clearColor];
    [btnTwo setTag:2];
    [btnTwo setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnTwo setTitle:@"week2" forState:UIControlStateNormal];
    [btnTwo setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnTwo addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnTwo];
     
    UIButton *btnThree = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnThree.frame = CGRectMake(40, 190, 200, 40);
    btnThree.backgroundColor=[UIColor clearColor];
    [btnThree setTag:3];
    [btnThree setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnThree setTitle:@"week3" forState:UIControlStateNormal];
    [btnThree setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnThree addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnThree];

    UIButton *btnFour = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnFour.frame = CGRectMake(40, 235, 200, 40);
    btnFour.backgroundColor=[UIColor clearColor];
    [btnFour setTag:4];
    [btnFour setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnFour setTitle:@"week4" forState:UIControlStateNormal];
    [btnFour setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnFour addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnFour];

    UIButton *btnFive = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnFive.frame = CGRectMake(40, 280, 200, 40);
    btnFive.backgroundColor=[UIColor clearColor];
    [btnFive setTag:5];
    [btnFive setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnFive setTitle:@"week5" forState:UIControlStateNormal];
    [btnFive setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnFive addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnFive];

    UIButton *btnSix = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnSix.frame = CGRectMake(40, 325, 200, 40);
    btnSix.backgroundColor=[UIColor clearColor];
    [btnSix setTag:6];
    [btnSix setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnSix setTitle:@"week6" forState:UIControlStateNormal];
    [btnSix setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSix addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnSix];

    UIButton *btnSenven= [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnSenven.frame = CGRectMake(40, 370, 200, 40);
    btnSenven.backgroundColor=[UIColor clearColor];
    [btnSenven setTag:7];
    [btnSenven setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnSenven setTitle:@"week7" forState:UIControlStateNormal];
    [btnSenven setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSenven addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnSenven];

    UIButton *btnEight = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnEight.frame = CGRectMake(40, 415, 200, 40);
    btnEight.backgroundColor=[UIColor clearColor];
    [btnEight setTag:8];
    [btnEight setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnEight setTitle:@"week8" forState:UIControlStateNormal];
    [btnEight setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnEight addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnEight];

    UIButton *btnNine = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnNine.frame = CGRectMake(40, 460, 200, 40);
    btnNine.backgroundColor=[UIColor clearColor];
    [btnNine setTag:9];
    [btnNine setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnNine setTitle:@"week9" forState:UIControlStateNormal];
    [btnNine setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnNine addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnNine];

    UIButton *btnTen = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnTen.frame = CGRectMake(40, 505, 200, 40);
    btnTen.backgroundColor=[UIColor clearColor];
    [btnTen setTag:10];
    [btnTen setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnTen setTitle:@"week10" forState:UIControlStateNormal];
    [btnTen setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnTen addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnTen];

    UIButton *btnEleven = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnEleven.frame = CGRectMake(40, 550, 200, 40);
    btnEleven.backgroundColor=[UIColor clearColor];
    [btnEleven setTag:11];
    [btnEleven setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnEleven setTitle:@"week11" forState:UIControlStateNormal];
    [btnEleven setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnEleven addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnEleven];

    UIButton *btnTwelve = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnTwelve.frame = CGRectMake(40, 595, 200, 40);
    btnTwelve.backgroundColor=[UIColor clearColor];
    [btnTwelve setTag:12];
    [btnTwelve setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnTwelve setTitle:@"week12" forState:UIControlStateNormal];
    [btnTwelve setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnTwelve addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnTwelve];

    UIButton *btnThrity = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnThrity.frame = CGRectMake(40, 640, 200, 40);
    btnThrity.backgroundColor=[UIColor clearColor];
    [btnThrity setTag:13];
    [btnThrity setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnThrity setTitle:@"week13" forState:UIControlStateNormal];
    [btnThrity setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnThrity addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnThrity];
    
    UIButton *btnFourth = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnFourth.frame = CGRectMake(40, 685, 200, 40);
    btnFourth.backgroundColor=[UIColor clearColor];
    [btnFourth setTag:14];
    [btnFourth setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnFourth setTitle:@"week14" forState:UIControlStateNormal];
    [btnFourth setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnFourth addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnFourth];

    UIButton *btnFiveth = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnFiveth.frame = CGRectMake(40, 730, 200, 40);
    btnFiveth.backgroundColor=[UIColor clearColor];
    [btnFiveth setTag:15];
    [btnFiveth setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnFiveth setTitle:@"week15" forState:UIControlStateNormal];
    [btnFiveth setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnFiveth addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnFiveth];

    UIButton *btnSixth = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnSixth.frame = CGRectMake(40, 775, 200, 40);
    btnSixth.backgroundColor=[UIColor clearColor];
    [btnSixth setTag:16];
    [btnSixth setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnSixth setTitle:@"week16" forState:UIControlStateNormal];
    [btnSixth setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSixth addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnSixth];

    UIButton *btnSeventh = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnSeventh.frame = CGRectMake(40, 820, 200, 40);
    btnSeventh.backgroundColor=[UIColor clearColor];
    [btnSeventh setTag:17];
    [btnSeventh setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnSeventh setTitle:@"week17" forState:UIControlStateNormal];
    [btnSeventh setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSeventh addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnSeventh];

    UIButton *btnEighth = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnEighth.frame = CGRectMake(40, 865, 200, 40);
    btnEighth.backgroundColor=[UIColor clearColor];
    [btnEighth setTag:18];
    [btnEighth setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnEighth setTitle:@"week18" forState:UIControlStateNormal];
    [btnEighth setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnEighth addTarget:self action:@selector(week:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnEighth];


        
    
	[super viewDidLoad];
    myWevView.delegate=self;
	myWevView2.delegate=self;
		
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *nsenter = @"http://elearn.shu.edu.tw/";
    NSURL *enter = [NSURL URLWithString:nsenter];
    NSString *nsindex = @"http://elearn.shu.edu.tw/learn/index.php";
    NSURL *index = [NSURL URLWithString:nsindex];
    //NSLog(@"%@",enter);
    NSString *myurl= myWevView.request.URL.absoluteString;
    NSString *myurl2= myWevView2.request.URL.absoluteString;
    
    //NSLog(@"%@",myurl); 
    
   if (![myurl2 isEqualToString:nsenter] && ![myurl isEqualToString:nsenter]) {
       [self getHtml];
    }
    if([myurl isEqualToString:nsindex])
    {
        myWevView.hidden=NO;
    }
    //if pass or id erro retype
    if (![myurl isEqualToString:nsenter] && ![myurl isEqualToString:nsindex]) 
    {
        NSLog(@"GGG");
        
        [myWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://elearn.shu.edu.tw"]]];
        [[[myWevView subviews] lastObject]setScrollEnabled:NO];
        
        myAlertView= [[UIAlertView alloc] initWithTitle:@"系統登入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入",nil];
        NSUserDefaults *userpassword;
        userpassword = [NSUserDefaults standardUserDefaults];
        [userpassword setObject:nil forKey:@"userpass"];
        [userpassword setObject:nil forKey:@"username"];
        [userpassword synchronize];              
        
    }     
    
    //NSLog(@"%@",myWevView.request.URL);
    NSString *pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpass"];
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"]; 
    //NSURL *erro="http://www.google.com/"+("%@",name);
    //NSLog(@"%@",erro);
    
    //if pass nil alertview show else type userdefault
    if ([myurl isEqualToString:nsenter]) 
    {
        if (pass==nil) {
            myAlertView= [[UIAlertView alloc] initWithTitle:@"系統登入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入",nil];
            
            [myAlertView show];
        }
        else{
            //NSLog(@"%@",name);  
            //NSLog(@"%@",pass);
            
            [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@'", name]];
            [myWevView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@'", pass]];
            [myWevView stringByEvaluatingJavaScriptFromString:@"var field3 = document.getElementsByTagName('button')[0];"
             "field3.click();"];
            
            
        }
    }
    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(interfaceOrientation == UIDeviceOrientationPortrait){
        
		return YES;
        
	} else {
        
		return NO;
	}
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
	
    [buttonRemoveDict removeAllObjects];
	[openButtons removeAllObjects];
	[progressViewDict removeAllObjects];
	[imgDict removeAllObjects];
	[homeListPdfs removeAllObjects];
	
}


- (void)dealloc {
	
	[documentsList release];
	
	[buttonRemoveDict release];
	[openButtons release];
	[progressViewDict release];
	[imgDict release];
	[downloadProgressContainerView release];
    [downloadProgressView release];
    
	[homeListPdfs release];
	
    [super dealloc];
}

@end
