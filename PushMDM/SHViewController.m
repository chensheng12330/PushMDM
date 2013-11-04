//
//  SHViewController.m
//  WebUserAgent
//
//  Created by sherwin.chen on 13-9-22.
//  Copyright (c) 2013年 sherwin.chen. All rights reserved.
//


#import "SHViewController.h"
#import "SHFTAnimationExample.h"
#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"

@interface SHViewController ()
-(void) floatAtionTag:(UIButton*) sender;

@end

@implementation SHViewController

- (void)viewDidLoad
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 20;
    self.view.frame = frame;
    
    self.view.backgroundColor = [UIColor whiteColor];

    [super viewDidLoad];
    
    self.myWebView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
    [self.view insertSubview:self.myWebView atIndex:0];
    
    NSString *configString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MainURL"];
    
    NSString *mainURLString = @"http://120.197.93.102/ycmp/temobi/index.html";
    if (configString != NULL && ![configString isEqualToString:@""]) {
        mainURLString = configString;
    }
    
    /////
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate= self;
    singleTap.cancelsTouchesInView = NO;
    
    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    [self.myWebView addGestureRecognizer:singleTap];  [singleTap release];
    
	// Do any additional setup after loading the view, typically from a nib.
    [_myWebView.scrollView setScrollEnabled:NO];
    _myWebView.backgroundColor = [UIColor whiteColor];
    mainRequest = [[NSURLRequest requestWithURL:[NSURL URLWithString:mainURLString] cachePolicy:0 timeoutInterval:24*60*60] retain];
    [_myWebView loadRequest:mainRequest];
    self.btnPress.showsTouchWhenHighlighted = YES;
    
    ///////////////////
    
    UIImage *storyMenuItemImage = [self imageWithImageSimple:[UIImage imageNamed:@"btn_press_nor.png"] scaledToSize:CGSizeMake(45, 45)];
    UIImage *storyMenuItemImagePressed = [self imageWithImageSimple:[UIImage imageNamed:@"btn_press_hight.png"] scaledToSize:CGSizeMake(45, 45)];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[self imageWithImageSimple:[UIImage imageNamed:@"btn4.png"] scaledToSize:CGSizeMake(35, 35)]
                                                         highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[self imageWithImageSimple:[UIImage imageNamed:@"btn3.png"] scaledToSize:CGSizeMake(35, 35)]
                                                         highlightedContentImage:nil];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[self imageWithImageSimple:[UIImage imageNamed:@"btn2.png"] scaledToSize:CGSizeMake(35, 35)]
                                                        highlightedContentImage:nil];
    // Thought MenuItem.

    
    NSArray *QCMenuItems = [[NSArray alloc] initWithObjects:cameraMenuItem, peopleMenuItem, musicMenuItem,nil];
    [cameraMenuItem release];
    [peopleMenuItem release];
    [musicMenuItem release];
 
    
    
    //CGRect rect =  self.view.bounds;
    
    
    QuadCurveMenu *viQuadCurveMenu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(0, 0, 320, 640) menus:QCMenuItems addImage:[self imageWithImageSimple:[UIImage imageNamed:@"btn1.png"] scaledToSize:CGSizeMake(45, 45)]];
    
    viQuadCurveMenu.delegate = self;
    
    //viQuadCurveMenu.userInteractionEnabled = YES;
    // set curveMenu view move rect
    float height = 0;
    if ([UIScreen mainScreen].bounds.size.height>500) {
        height = 430;
    }
    else
    {
        height = 379;
    }
    
    CGRect rect = CGRectMake(128, 108, 284, height); //379
    
    [SHFTAnimationExample MoveView:viQuadCurveMenu inRect:rect];
    
    [self.view addSubview:viQuadCurveMenu];
    
    /*
    NSArray *imageNames = @[@"icon_home@2x",@"icon_next@2x",@"icon_pre@2x"];
    NSMutableArray *Items = [[NSMutableArray alloc] init];
    
    for (int i=0; i<3; i++) {
        UIView *twitterItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
        twitterItem.tag = i+1;
//        [twitterItem setMenuActionWithBlock:^{
//            NSLog(@"tapped twitter item");
//            //[self floatAtionTag:twitterItem.tag];
//        }];
        
        UIButton *twitterIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [twitterIcon setFrame:CGRectMake(0, 0, 40, 40)];
        twitterIcon.tag = i+1;
        [twitterIcon addTarget:self action:@selector(floatAtionTag:) forControlEvents:UIControlEventTouchUpInside];
        
        //[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [twitterIcon setImage:[UIImage imageNamed:[imageNames objectAtIndex:i]]  forState:UIControlStateNormal];
        twitterIcon.showsTouchWhenHighlighted = YES;
        twitterIcon.adjustsImageWhenHighlighted = YES;
        
        [twitterItem addSubview:twitterIcon];
        [Items addObject:twitterItem];
        
    
        [twitterItem release];
    }
        
    _sideMenu = [[HMSideMenu alloc] initWithItems:Items]; [Items release];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];

    CGRect rect = self.view.bounds;
    rect.origin.x += 25;
    rect.origin.y += 25;
    rect.size.height -= 50;
    rect.size.width  -= 50;
    
    [SHFTAnimationExample MoveView:self.btnPress  inRect:rect];
     */
    
}

- (IBAction)toggleMenu:(id)sender {
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    else
        [self.sideMenu open];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#define degreesToRadians(x) (M_PI*(x)/180.0)
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
        self.btnPress.transform = CGAffineTransformIdentity;
        self.btnPress.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
        
        float y =0;
        if (self.btnPress.frame.origin.y>320) {
            y = 320 - 50;
        }
        self.btnPress.frame = CGRectMake(self.btnPress.frame.origin.x, y, 50, 50);
        
        
    }
    else
    {
        
    }
    
    NSLog(@"x:%f y:%f",self.btnPress.frame.origin.x, self.btnPress.frame.origin.y);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    if (self.sideMenu.isOpen) {
        [self.sideMenu close];
    }
    return;
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    self.sideMenu = nil;
    [_myWebView     release];
    [_btnPress      release];
    [mainRequest    release];
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_myWebView.scrollView setScrollEnabled:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)viewDidUnload {
    [self setBtnPress:nil];
    [super viewDidUnload];
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    int tag = idx;
    if (tag ==0) { //主页
        [_myWebView loadRequest:mainRequest];
    }
    else if (tag == 3)//后退
    {
        [_myWebView goBack];
    }
    else if(tag ==2 )//
    {
        [_myWebView goForward];
    }
    
    //[self.sideMenu close];
    return;
}

-(void) floatAtionTag:(UIButton*) sender
{
    int tag = sender.tag;
    
    if (tag ==3) { //前进
        [_myWebView loadRequest:mainRequest];
    }
    else if(tag ==1 )//主页
    {
        [_myWebView goForward];
    }else if (tag == 2)//后退
    {
       [_myWebView goBack];
    }
    
    //[self.sideMenu close];
    return;
}


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);// Tell the old image to draw in this newcontext, with the desired// new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)]; // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext(); // End the context
    UIGraphicsEndImageContext(); // Return the new image.
    return newImage;
}
@end
