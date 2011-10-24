//
//  DocumentViewController.h
//  FastPDFKitTest
//
//  Created by Nicolò Tosi on 8/25/10.
//  Copyright 2010 MobFarm S.r.l. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MFDocumentViewController.h"
#import "MFDocumentViewControllerDelegate.h"
#import "BookmarkViewControllerDelegate.h"
#import "SearchViewControllerDelegate.h"
#import "MiniSearchViewControllerDelegate.h"
#import "OutlineViewControllerDelegate.h"
#import "MFHorizontalSlider.h"
#import "TextDisplayViewControllerDelegate.h"
#import "MediaPlayer/MediaPlayer.h"

@class BookmarkViewController;
@class SearchViewController;
@class TextDisplayViewController;
@class SearchManager;
@class MiniSearchView;
@class MFTextItem;

#define FPK_REUSABLE_VIEW_NONE 0
#define FPK_REUSABLE_VIEW_SEARCH 1
#define FPK_REUSABLE_VIEW_TEXT 2
#define FPK_REUSABLE_VIEW_OUTLINE 3
#define FPK_REUSABLE_VIEW_BOOKMARK 4

#define FPK_SEARCH_VIEW_MODE_MINI 0
#define FPK_SEARCH_VIEW_MODE_FULL 1

@interface ReaderViewController : MFDocumentViewController <MFSliderDelegate,MFDocumentViewControllerDelegate,UIPopoverControllerDelegate,TextDisplayViewControllerDelegate,SearchViewControllerDelegate,BookmarkViewControllerDelegate,OutlineViewControllerDelegate,MiniSearchViewControllerDelegate> {
	
	// Thumbnail view and stuff.
	UIImageView * thumbnailView;
	
	// Text extraction controller and stuff.
	MFHorizontalSlider * thumbsliderHorizontal;
	UIView * thumbSliderViewHorizontal;
	
	NSMutableArray * thumbImgArray;
	
	BOOL pdfOpen;
	BOOL thumbsViewVisible;
	
	UIBarButtonItem *changeModeBarButtonItem;
	UIBarButtonItem *zoomLockBarButtonItem;
	UIBarButtonItem *changeDirectionBarButtonItem;
	UIBarButtonItem *changeLeadBarButtonItem;
	UIBarButtonItem *searchBarButtonItem;
	
	UILabel * numberOfPageTitleToolbar;
	UILabel * pageNumLabel;
	
	id senderText;
	id senderSearch;
	
	UIImage * imgModeSingle;
	UIImage * imgModeDouble;
	
	UIImage * imgZoomLock;
	UIImage * imgZoomUnlock;
	
	UIImage * imgl2r;
	UIImage * imgr2l;
	
	UIImage * imgLeadRight;
	UIImage * imgLeadLeft;
	
	CGFloat toolbarHeight;
	CGFloat thumbSliderViewBorderWidth;
	CGFloat thumbSliderViewHeight;
	
	UIToolbar * rollawayToolbar;
	
	BOOL waitingForTextInput;
	
	NSString * documentId;  // Keep an unique reference to the document in the application (could be an ID, the name, etc).
	
	// Text search controller and stuff.
	SearchViewController * searchViewController;
	SearchManager * searchManager;
	MiniSearchView * miniSearchView;
	TextDisplayViewController * textDisplayViewController;
	
	BOOL hudHidden; // General HUD visible flag.
	BOOL multimediaVisible;
    
	UIPopoverController *reusablePopover;   // This is a single popover controller that will be used to display alternate content view controller.
    NSUInteger currentReusableView;         // This flag is used to keep track of what alternate controller is displayed to the user.
    NSUInteger currentSearchViewMode;       // This flag keep track of which search view is currently in use, full or mini.
    
	UILabel * pageLabel;    // Page label at the bottom of the screen.
	UISlider * pageSlider;  // Page slider at the bottom of the screen.
    
    // Thumbnail related stuff.
    NSUInteger currentThumbPage;
    NSFileManager * thumbFileManager;
    BOOL thumbnailize;
}

@property (nonatomic,retain) UIImage * imgModeSingle;
@property (nonatomic,retain) UIImage * imgModeDouble;
@property (nonatomic,retain) UIImage * imgZoomLock;
@property (nonatomic,retain) UIImage * imgZoomUnlock;
@property (nonatomic,retain) UIImage * imgl2r;
@property (nonatomic,retain) UIImage * imgr2l;
@property (nonatomic,retain) UIImage * imgLeadRight;
@property (nonatomic,retain) UIImage * imgLeadLeft;

-(void)setNumberOfPageToolbar;

-(void)showToolbar;
-(void)hideToolbar;

@property (nonatomic, retain) UIToolbar * rollawayToolbar;
@property (nonatomic, retain) UILabel * pageNumLabel;
@property (nonatomic, copy) NSString * documentId;

@property (nonatomic, retain) UISlider * pageSlider;

@property (nonatomic, retain) UIBarButtonItem * searchBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * changeModeBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * zoomLockBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * changeDirectionBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * changeLeadBarButtonItem;

@property (nonatomic, retain) UIBarButtonItem * bookmarkBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * textBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * numberOfPageTitleBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * dismissBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * outlineBarButtonItem;

@property (nonatomic, retain) UILabel * numberOfPageTitleToolbar;

@property (nonatomic, retain) NSMutableArray *thumbImgArray;

@property (nonatomic, retain) MFHorizontalSlider *thumbsliderHorizontal;
@property (nonatomic, retain) UIView *thumbSliderViewHorizontal;

@property (nonatomic, retain) SearchViewController * searchViewController;
@property (nonatomic, retain) SearchManager * searchManager;
@property (nonatomic, retain) MiniSearchView * miniSearchView;
@property (nonatomic, retain) TextDisplayViewController * textDisplayViewController;

@property (nonatomic, readwrite, getter = isMultimediaVisible) BOOL multimediaVisible;

@property (nonatomic, retain) UIPopoverController * reusablePopover;


// Thumbnail stuff.
@property (retain) NSFileManager * thumbFileManager;

-(void)hideHorizontalThumbnails;
-(void)showHorizontalThumbnails;
-(void)dismissAlternateViewController;
-(void)playVideo:(NSString *)path local:(BOOL)isLocal;
-(void)playAudio:(NSString *)path local:(BOOL)isLocal;
-(void)showWebView:(NSString *)path local:(BOOL)isLocal;

-(void)showToolbar;
-(void)hideToolbar;
-(void)prepareToolbar;
-(void)prepareThumbSlider;

@end
