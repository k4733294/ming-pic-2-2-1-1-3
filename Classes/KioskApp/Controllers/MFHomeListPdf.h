//
//  MFHomeListPdf.h
//  RoadView
//
//  Created by Matteo Gavagnin on 26/03/09.
//  Copyright 2009 MobFarm s.r.l.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MenuViewController_Kiosk.h"

@interface MFHomeListPdf : UIViewController <UIActionSheetDelegate>{
	
	id object;
	NSString *thumbName;
	CGSize size;
	NSString *page;
	NSString *downloadUrl;
    NSString *titleOfPdf;
	id delegate;
	id dataSource;
	UIImageView *corner;
	BOOL temp;
	int documentNumber;
	
	ASIHTTPRequest *httpRequest;
	
	BOOL pdfInDownload;
    BOOL isPdfLink;
	MenuViewController_Kiosk *menuViewController;
	NSString *pdfToDownload;
	UIButton *removeButton;
	UIButton *openButton;
	UIButton *openButtonFromImage;
	UIProgressView *progressDownload;
	UIImageView *thumbImage;
	
    BOOL downloadPdfStopped;
    //elearn
    IBOutlet UIWebView *myWevView;
    IBOutlet UITextField *accoutName;   
    IBOutlet UITextField *accoutPassword;  
    UIAlertView *myAlertView;
    
}

//elearn

@property (nonatomic,retain) UIWebView *myWevView;
@property (nonatomic,retain) UIAlertView *myAlertView;

-(IBAction) Login:(id)sender;
-(IBAction)start:(id)sender;


//elearn end
@property (nonatomic,copy) NSString *thumbName;
@property (nonatomic,assign) id object;
@property (nonatomic,assign) id dataSource;
@property (nonatomic,retain) UIImageView *corner;

@property (nonatomic,copy) NSString *downloadUrl;
@property (nonatomic) BOOL temp;
@property (nonatomic) BOOL isPdfLink;
@property (nonatomic) BOOL downloadPdfStopped;
@property (nonatomic, assign) MenuViewController_Kiosk *menuViewController;
@property (nonatomic, assign) int documentNumber;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *titleOfPdf;
@property (nonatomic,retain ) UIButton *removeButton;
@property (nonatomic,retain ) UIButton *openButton;
@property (nonatomic,retain ) UIButton *openButtonFromImage;
@property (nonatomic,retain ) UIProgressView *progressDownload;
@property (nonatomic,retain ) UIImageView *thumbImage;
@property (nonatomic,retain) ASIHTTPRequest * httpRequest;

- (id)initWithName:(NSString *)Page andTitoloPdf:(NSString *)titoloPdf andLinkPdf:(NSString *)linkpdf andnumOfDoc:(int)numDoc andImage:(NSString *)_image andSize:(CGSize)_size;
- (void)setSelected:(BOOL)selected;
- (void)updateCorner;
- (void)downloadPDF:(id)sender withUrl:(NSString *)_url andName:(NSString *)nomefilepdf;
- (void)downloadImage:(id)sender withUrl:(NSString *)_url andName:(NSString *)nomefilepdf;
- (BOOL)checkIfPDfLink:(NSString *)url;

@end
