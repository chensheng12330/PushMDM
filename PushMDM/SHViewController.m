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
#import "MBProgressHUD.h"
#import "QuadCurveMenuItem.h"
#import <CommonCrypto/CommonDigest.h>
#import "RemoteNotificationManage.h"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)


@interface SHViewController ()
-(void) floatAtionTag:(UIButton*) sender;

@property (nonatomic, retain) NSString *jsAPI;
@end

@implementation SHViewController

- (id)init
{
    self = [super init];
    if (self) {
        activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activeView setFrame:CGRectMake(150, [[UIScreen mainScreen] bounds].size.height/2.0-10,20, 20)];
        [activeView startAnimating];
        
        self.jsAPI = @"var iosShareContent; var iosImageUrl; \
        var tmbWeibo = \
        { SocialShare : function (content,imageUrl)\
            {\
                iosShareContent = content;\
                iosImageUrl = imageUrl;\
                window.location = \"gap://SocialShare\";\
            },\
          GetContent : function(){return iosShareContent;},\
          GetImageUrl: function(){return iosImageUrl;}\
        }";
    }
    return self;
}

- (void)viewDidLoad
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    if (DEVICE_IS_IPHONE5 || DEVICE_IS_IOS7) {
        if (self.navigationController.navigationBar==Nil || self.navigationController.navigationBarHidden) {
            frame.origin.y += 20;
            frame.size.height -=20;
        }
    }
    else
    {
        if (self.navigationController.navigationBar==Nil || self.navigationController.navigationBarHidden) {
            frame.size.height -= 20 ;
        }
        else{
            frame.size.height -= 20 + 44;
        }
    }
    self.view.frame = frame;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    self.myWebView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
    [self.view insertSubview:self.myWebView atIndex:0];
    [self.myWebView addSubview:activeView];
    
    /////
    //UM初使化
    [self initSocialShare];
    
    /////
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate= self;
    singleTap.cancelsTouchesInView = NO;
    
    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    [self.myWebView addGestureRecognizer:singleTap];  [singleTap release];
    
	// Do any additional setup after loading the view, typically from a nib.
    [_myWebView.scrollView setScrollEnabled:NO];
    _myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.delegate = self;
    
    [_myWebView loadRequest:_mainRequest];
    
    ///*
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //[self.myWebView loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
   // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    //[self.myWebView loadRequest:request];
    //*/
    
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
    
    viQuadCurveMenu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(0, 0, 320, 640) menus:QCMenuItems addImage:[self imageWithImageSimple:[UIImage imageNamed:@"btn1.png"] scaledToSize:CGSizeMake(45, 45)]];
    
    viQuadCurveMenu.delegate = self;
    
    //viQuadCurveMenu.userInteractionEnabled = YES;
    // set curveMenu view move rect
    float height = 0;
    if ([UIScreen mainScreen].bounds.size.height>500) {
        height = 470;
    }
    else
    {
        height = 379;
    }
    
    CGRect rect = CGRectMake(128, 108, 284, height); //379
    
    [SHFTAnimationExample MoveView:viQuadCurveMenu inRect:rect];
    
    [self.view addSubview:viQuadCurveMenu];
    
    [QCMenuItems release];
    [viQuadCurveMenu release];
    
    //[viQuadCurveMenu setHidden:YES];
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
    
    self.mainRequest = nil;
    self.sideMenu    = nil;
    [_myWebView     release];
    [_btnPress      release];

    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *jsScheme = request.mainDocumentURL.scheme;
   
    if ([jsScheme isEqualToString:@"gap"]) {
        NSString *jsHost = request.mainDocumentURL.host;
        if ([jsHost isEqualToString:@"SocialShare"]) {
            //获取数据
            NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"tmbWeibo.GetContent();"];
            NSString *imageURL= [webView stringByEvaluatingJavaScriptFromString:@"tmbWeibo.GetImageUrl();"];//GetImageUrl
            //分享
            [self UMSocialShare:content ImageURL:imageURL];
            return NO;
        }
    }
    //如果是用户登陆成功请求

    
    //NSLog(@"%@",request);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.myWebView stringByEvaluatingJavaScriptFromString:self.jsAPI];
    
    [activeView removeFromSuperview];
    
    [viQuadCurveMenu setHidden:NO];
    [_myWebView.scrollView setScrollEnabled:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [viQuadCurveMenu setHidden:NO];
}

- (void)viewDidUnload {
    [self setBtnPress:nil];
    [super viewDidUnload];
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    int tag = idx;
    if (tag ==0) { //主页
        [_myWebView loadRequest:_mainRequest];
    }
    else if (tag == 1)//后退
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
        [_myWebView loadRequest:_mainRequest];
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

-(void) webViewReload:(NSURLRequest *) mainRequest
{
    self.mainRequest = mainRequest;
    [_myWebView loadRequest:mainRequest];
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

//#define UmengAppkey (@"514c70b356240bcd04006f9a") //myself

#define UmengAppkey @"5211818556240bc9ee01db2f"  //UM
-(void) initSocialShare
{
    if ([UMSocialData appKey]==NULL || [UMSocialData appKey].length <1) {
        
//        //打开调试log的开关
//        [UMSocialData openLog:YES];
//        //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
//        [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
//        
//        //设置友盟社会化组件appkey
//        [UMSocialData setAppKey:UmengAppkey];
//        [UMSocialConfig setTheme:UMSocialThemeWhite];
//        //设置微信AppId
//        [UMSocialConfig setWXAppId:@"wx2ea7615a6d25ba64" url:@"http://www.temobi.com"];
//        //打开Qzone的SSO开关
//        [UMSocialConfig setSupportQzoneSSO:NO importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
//        //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
//        [UMSocialConfig setQQAppId:@"100571325" url:@"http://www.temobi.com" importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
//        //打开新浪微博的SSO开关
//        [UMSocialConfig setSupportSinaSSO:NO];
        
        //打开调试log的开关
        [UMSocialData openLog:YES];
        
        //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
        [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
        
        //设置友盟社会化组件appkey
        [UMSocialData setAppKey:UmengAppkey];
        
        NSString *configString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MainURL"];
        
        //设置微信AppId
        [UMSocialConfig setWXAppId:@"wxd9a39c7122aa6516" url:configString];
        //打开Qzone的SSO开关
        [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
        //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
        [UMSocialConfig setQQAppId:@"100424468" url:configString importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
        //打开新浪微博的SSO开关
        [UMSocialConfig setSupportSinaSSO:YES];
    }
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    
    //查找本地是否存在图片
    UIImage * result = [self getCacheImageWithURL:fileURL];

    if (result) {
        return result;
    }
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    [self saveCacheImage:result WithURL:fileURL];
    return result;
}


-(void) UMSocialShare:(NSString* )content ImageURL:(NSString*) url
{
    __block UIImage *image = NULL;
    if (url!=NULL && url.length!=0) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"正在加载您的贺卡图片,请稍等...";
        
        [hud showAnimated:YES whileExecutingBlock:^{
            image = [[self getImageFromURL:url] retain];
            
        } completionBlock:^{
            [hud removeFromSuperview];
            [hud release];
            
            NSArray* snsNames = @[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToEmail,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline];
            [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:content shareImage:image shareToSnsNames:snsNames delegate:self];
            [image autorelease];
        }];
    }
    
    
    return;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSString *info=@"";
    
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        info = @"您的贺卡已成功分享.";
    }
    else if(response.responseCode == UMSResponseCodeCancel)
    {
        return;
    }
    else
    {
        info = @"未知原因，您的贺卡分享失败.";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:info delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    return;
}

#pragma mark - imageCache
- (NSString *) mdd5:(NSString *)keyString
{
    const char *cStr = [keyString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}


//获取本地缓存的图片数据
-(UIImage*) getCacheImageWithURL:(NSString*)strURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = documentsDirectory;//[documentsDirectory stringByAppendingPathComponent:@"tmAlbumImages"];
    
    NSString *cacheKey = [self mdd5:strURL];
    NSString *filePath = [cacheDirectoryName stringByAppendingPathComponent:cacheKey];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    return nil;
}

-(void) saveCacheImage:(UIImage*)image WithURL:(NSString*)strURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = documentsDirectory;//[documentsDirectory stringByAppendingPathComponent:@"tmAlbumImages"];
    
    NSString *cacheKey = [self mdd5:strURL];
    NSString *filePath = [cacheDirectoryName stringByAppendingPathComponent:cacheKey];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [UIImageJPEGRepresentation(image,1) writeToFile:filePath atomically:YES];
    }
    return;
}
@end
