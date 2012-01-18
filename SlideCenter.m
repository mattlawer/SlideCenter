#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BBWeeAppController-Protocol.h"

#import "SCInfoView.h"
#import "SCSlideView.h"
#import "TouchFix/TouchFix.h"
#import "Debug.h"

#define VIEW_HEIGHT 160.0f

//#define SHUFFLE_KEY @"Shuffle"  // NO
#define DELAY_KEY   @"SecondsPerSlide" // 3

@interface SlideCenterController : NSObject <BBWeeAppController, UIScrollViewDelegate>
{
    UIView *_view;
    UIScrollView *_scrollView;
    SCSlideView *_imageView;
    SCInfoView *_settingsView;
    UIActivityIndicatorView *_indicator;
    
    // Load photos
    ALAssetsLibrary *library;
    NSMutableArray *assets;
    
    BOOL _isDisplaying;
    BOOL _settingsVisible;
    
    BOOL scanGroup;
    BOOL scanPics;
}

@property (nonatomic, retain) SCSlideView *imageView;
@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, assign) BOOL isDisplaying;
@property (nonatomic, assign) BOOL settingsVisible;

- (id)init;
- (UIView *)view;
- (void) loadAssets;
- (BOOL) isScanning;
- (NSInteger) changeDelay;
- (void) detachedChangeImage;

@end

@implementation SlideCenterController
@synthesize imageView = _imageView;
@synthesize assets;
@synthesize isDisplaying = _isDisplaying;
@synthesize settingsVisible = _settingsVisible;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [library release];
    [assets release];
    [_indicator release];
    [_imageView release];
    [_settingsView release];
    [_scrollView release];
    [_view release];
    [super dealloc];
}

- (UIView *)view
{
    if (_view == nil)
    {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, VIEW_HEIGHT)];
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _view.backgroundColor = [UIColor clearColor];
        
        
        _scrollView = [[UIScrollView alloc] initWithFrame:_view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        
        // Add Images
        CGFloat width = _view.frame.size.width;
        
        _imageView = [[SCSlideView alloc] initWithFrame:CGRectMake(2.0, 0.0, width-4.0, VIEW_HEIGHT)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
        info.frame = CGRectMake(width-30.0, VIEW_HEIGHT-26.0, 30.0, 30.0);
        info.showsTouchWhenHighlighted = YES;
        info.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [info addTarget:self action:@selector(showInfos) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:info];
        [_imageView.layer setCornerRadius:8.0];
        [_imageView setClipsToBounds:YES];
        
        [_scrollView addSubview:_imageView];
        
        _scrollView.contentSize = CGSizeMake(width*2.0, VIEW_HEIGHT);
        
        _settingsView = [[SCInfoView alloc] initWithFrame:CGRectMake(width+2, 0.0, width-4, VIEW_HEIGHT)];
        _settingsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _settingsView.backgroundColor = [UIColor clearColor];
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(5.0, 5.0, 40.0, 30.0);
        back.showsTouchWhenHighlighted = YES;
        [back setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SlideCenter.bundle/back.png"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(hideInfos) forControlEvents:UIControlEventTouchUpInside];
        [_settingsView addSubview:back];
        [_scrollView addSubview:_settingsView];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _indicator.frame = CGRectMake((width/2.0)-20.0, (VIEW_HEIGHT/2.0)-20.0, 40.0, 40.0);
        _indicator.hidesWhenStopped = YES;
        [_scrollView addSubview:_indicator];
        
        [_view addSubview:_scrollView];
        
        
    }
    return _view;
}


- (float)viewHeight
{
    return VIEW_HEIGHT;
}

- (void)viewWillAppear {
    DBGLog(@"SlideCenter appear");
    self.isDisplaying = YES;
    [self loadAssets];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeImage) object:nil];
    [self performSelector:@selector(changeImage) withObject:nil afterDelay:0.1];
}

- (void)viewDidDisappear {
    self.isDisplaying = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeImage) object:nil];
}

- (void)willAnimateRotationToInterfaceOrientation:(int)arg1
{
	CGRect rect= _scrollView.frame;
    
	rect.size.width= UIInterfaceOrientationIsLandscape(arg1) ? 480.0 : 320.0;
    _scrollView.frame = rect;
    _scrollView.contentSize = CGSizeMake(2*rect.size.width, VIEW_HEIGHT);
    CGRect settingsFrame = CGRectMake(rect.size.width+2, 0.0, rect.size.width-4, VIEW_HEIGHT);
    _settingsView.frame = settingsFrame;
    
    [_scrollView setContentOffset:CGPointMake(0.0, 0.0)];
}

- (id)launchURLForTapLocation:(CGPoint)point
{    
    // Touch simulation. Code from WidgetTask.
    UITouch *touch = [[UITouch alloc] initWithPoint:[_view convertPoint:point toView:_view.window] andView:[self view]];
    UIEvent *eventDown = [[UIEvent alloc] initWithTouch:touch];    
    [touch.view touchesBegan:[eventDown allTouches] withEvent:eventDown];
    [touch setPhase:UITouchPhaseEnded];
    UIEvent *eventUp = [[UIEvent alloc] initWithTouch:touch];
    [touch.view touchesEnded:[eventUp allTouches] withEvent:eventUp];
    [eventDown release];
    [eventUp release];
    [touch release];
    return nil;
}


- (void) changeImage {
    
    [NSThread detachNewThreadSelector:@selector(detachedChangeImage) toTarget:self withObject:nil];
    if (self.isDisplaying) {
        DBGLog(@"delay : %i",[self changeDelay]);
        [self performSelector:@selector(changeImage) withObject:nil afterDelay:[self changeDelay]+0.6];
    }
    
}

- (void) detachedChangeImage {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    DBGLog(@"\nisScanning : %@\nassets.count : %i",[self isScanning] ? @"YES" : @"NO",[assets count]);
    if (![self isScanning] && [assets count] > 0) {
        ALAsset *img = [assets objectAtIndex:arc4random()%[assets count]];
        DBGLog(@"img : %@",img);
        UIImage *newImg = [UIImage imageWithCGImage:[[img defaultRepresentation] fullScreenImage]];
        [self.imageView setImage:newImg];
    }
    [pool release];
    
}


- (void) loadAssets {
    
    if ([self isScanning]) {
        DBGLog(@"loadAssets -> isScanning -> return");
        return;
    }
    
    [_indicator startAnimating];
    scanGroup = YES;
    scanPics = YES;
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableArray *assetURLDictionaries = [[[NSMutableArray alloc] init] autorelease];
        
        // Asset enumerator Block
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result != nil) {
                if(![assetURLDictionaries containsObject:[result valueForProperty:ALAssetPropertyURLs]]) {
                    if(![[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                        if ([result valueForProperty:ALAssetPropertyURLs] != nil) {
                            [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        }
                        [assets addObject:result];
                    }
                }
            }
            if (stop && !scanGroup) {
                scanPics = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_indicator stopAnimating];
                });
            }
        };
        // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            scanGroup = !stop;
            if (group != nil){
                [group enumerateAssetsUsingBlock:assetEnumerator];
            }else if (!scanGroup && ([assets count] == 0)) {
                DBGLog(@"\n\nNo images found\n\n");
                scanPics = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_indicator stopAnimating];
                    [_imageView setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SlideCenter.bundle/empty.png"]];
                });
            }
            //NSLog(@"group : %@", [group description]);//Displays count of total photos
        };
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            scanGroup = NO;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@", [error description]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            //NSLog(@"A problem occured %@", [error description]);
        };
        
        // Enumerate Albums
        // [assets release];
        assets = nil;
        
        [library release];
        library = nil;
        
        assets = [[NSMutableArray alloc] init];
        library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator
                             failureBlock:assetGroupEnumberatorFailure];               
    });   
    
}

- (BOOL) isScanning {
    return scanPics; 
}

- (void) showInfos {
    [self setSettingsVisible:YES];
}

- (void) hideInfos {
    [self setSettingsVisible:NO];
}

- (void) setSettingsVisible:(BOOL)setV {
    //NSLog(@"setSettingsVisible:%@",setV?@"YES":@"NO");
    _settingsVisible = setV;
    [_scrollView scrollRectToVisible:CGRectMake(self.settingsVisible ? _scrollView.bounds.size.width : 0.0, 0.0, _scrollView.bounds.size.width, VIEW_HEIGHT) animated:YES];
}

- (NSInteger) changeDelay {
    NSInteger seconds = 3;
    NSDictionary *slideshowprefs = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.apple.mobileslideshow.plist"]];
    if ([[slideshowprefs allKeys] containsObject:DELAY_KEY]) {
        seconds = [[slideshowprefs objectForKey:DELAY_KEY] integerValue];
    }
    return seconds;
}

@end