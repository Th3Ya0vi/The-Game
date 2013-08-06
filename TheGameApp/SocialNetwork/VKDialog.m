//
//  SocDialog.m
//  SocialClient
//
//  Created by Admin on 28.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "VKDialog.h"

#import "Vkontakte.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};

static CGFloat kTransitionDuration = 0.3;

static CGFloat kPadding = 0;
static CGFloat kBorderWidth = 10;

///////////////////////////////////////////////////////////////////////////////////////////////////


@implementation VKDialog {
    BOOL _everShown;
}

#pragma mark - init

- (id)init {
    NSLog(@"init");

    if ((self = [super initWithFrame:CGRectZero])) {
        _showingKeyboard = NO;
        _everShown = NO;
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 480, 480)];
        _webView.delegate = self;
        //_webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_webView];
        
        UIImage* closeImage = [UIImage imageNamed:@"FacebookSDKResources.bundle/FBDialog/images/close.png"];
        
        UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton setTitleColor:color forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(cancel)
               forControlEvents:UIControlEventTouchUpInside];
        
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];        
        _closeButton.showsTouchWhenHighlighted = YES;
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_closeButton];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                    UIActivityIndicatorViewStyleWhiteLarge];
        if ([_spinner respondsToSelector:@selector(setColor:)]) {
            [_spinner setColor:[UIColor grayColor]];
        } else {
            [_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        }
        _spinner.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_spinner];
        _modalBackgroundView = [[UIView alloc] init];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    _webView.delegate = nil;
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == _orientation) {
        return NO;
    } else {
        return orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown
        || orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight;
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawRect:rect fill:kBorderGray radius:0];
    
    CGRect webRect = CGRectMake(
                                ceil(rect.origin.x + kBorderWidth), ceil(rect.origin.y + kBorderWidth)+1,
                                rect.size.width - kBorderWidth*2, _webView.frame.size.height+1);
    
    [self strokeLines:webRect stroke:kBorderBlack];
}

#pragma mark - public

- (void)show {
    NSLog(@"show");

    NSString *authLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&scope=wall,photos,friends,offline,docs&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token", _appID];
    NSURL *url = [NSURL URLWithString:authLink];
	[_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self sizeToFitOrientation:NO];
    
    CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;
    [_closeButton sizeToFit];
    
    _closeButton.frame = CGRectMake(
                                    2,
                                    2,
                                    29,
                                    29);
    
    _webView.frame = CGRectMake(
                                kBorderWidth+1,
                                kBorderWidth+1,
                                innerWidth,
                                self.frame.size.height - (1 + kBorderWidth*2));
    
    //if (!_isViewInvisible) {
    [self showSpinner];
    [self showWebView];
    //}
}






#pragma mark - webview

// Display the dialog's WebView with a slick pop-up animation
- (void)showWebView {
    NSLog(@"show webview");

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    _modalBackgroundView.frame = window.frame;
    [_modalBackgroundView addSubview:self];
    [window addSubview:_modalBackgroundView];
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
    _everShown = YES;
    [self addObservers];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"webview shouldStartLoadWithRequest %@", [request.URL absoluteString]);

    
    NSURL* URL = request.URL;
    
    if ([[URL absoluteString] isEqualToString:@"http://api.vk.com/blank.html#error=access_denied&error_reason=user_denied&error_description=User%20denied%20your%20request"]) {
		
        //[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
        [self dismiss:YES];
        
		return NO;
	}
	NSLog(@"Request: %@", [URL absoluteString]);
	return YES;
    
    /*
    if ([url.scheme isEqualToString:@"fbconnect"]) {
        if ([[url.resourceSpecifier substringToIndex:8] isEqualToString:@"//cancel"]) {
            NSString * errorCode = [self getStringFromUrl:[url absoluteString] needle:@"error_code="];
            NSString * errorStr = [self getStringFromUrl:[url absoluteString] needle:@"error_msg="];
            if (errorCode) {
                NSDictionary * errorData = [NSDictionary dictionaryWithObject:errorStr forKey:@"error_msg"];
                NSError * error = [NSError errorWithDomain:@"facebookErrDomain"
                                                      code:[errorCode intValue]
                                                  userInfo:errorData];
                [self dismissWithError:error animated:YES];
            } else {
                [self dialogDidCancel:url];
            }
        } else {
            if (_frictionlessSettings.enabled) {
                [self dialogSuccessHandleFrictionlessResponses:url];
            }
            [self dialogDidSucceed:url];
        }
        return NO;
    } else if ([_loadingURL isEqual:url]) {
        return YES;
    } else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([_delegate respondsToSelector:@selector(dialog:shouldOpenURLInExternalBrowser:)]) {
            if (![_delegate dialog:self shouldOpenURLInExternalBrowser:url]) {
                return NO;
            }
        }
        
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    } else {
        return YES;
    }
     */
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webview webViewDidFinishLoad");
    
    [self hideSpinner];
    [self updateWebOrientation];
    
    
    if ([_webView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
		NSString *accessToken = [self.class stringBetweenString:@"access_token="
                                                                 andString:@"&"
                                                               innerString:[[[webView request] URL] absoluteString]];
		
		NSArray *userAr = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
		NSString *user_id = [userAr lastObject];
		NSLog(@"User id: %@", user_id);
		if(user_id){
			[[NSUserDefaults standardUserDefaults] setObject:user_id forKey:kSHKVkonakteUserId];
		}
		
		if(accessToken){
			[[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kSHKVkontakteAccessTokenKey];
            
			[[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] dateByAddingTimeInterval:86400] forKey:kSHKVkontakteExpiryDateKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		NSLog(@"webView response: %@",[[[webView request] URL] absoluteString]);
		
        Vkontakte* vk = (Vkontakte*)self.delegate;
        [vk authComplete];
        
		//[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
        [self dismiss:YES];
        
	} else if ([_webView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
		NSLog(@"Error: %@", _webView.request.URL.absoluteString);
		//[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
        [self dismiss:YES];
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webview didFailLoadWithError %@", error);
    
	//[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
    [self dismiss:YES];
    
    /*
    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
    // -999 == "Operation could not be completed", note -999 occurs when the user clicks away before
    // the page has completely loaded, if we find cases where we want this to result in dialog failure
    // (usually this just means quick-user), then we should add something more robust here to account
    // for differences in application needs
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
        //[self dismissWithError:error animated:YES];
        [self dismiss:YES];
    }
     */
}



#pragma mark - Methods

+ (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str
{
	NSScanner* scanner = [NSScanner scannerWithString:str];
	[scanner setCharactersToBeSkipped:nil];
	[scanner scanUpToString:start intoString:NULL];
	if ([scanner scanString:start intoString:NULL]) {
		NSString* result = nil;
		if ([scanner scanUpToString:end intoString:&result]) {
			return result;
		}
	}
	return nil;
}


#pragma mark - dismiss

- (void)postDismissCleanup {
    NSLog(@"post dismiss cleanup");

    [self removeObservers];
    [self removeFromSuperview];
    [_modalBackgroundView removeFromSuperview];
    
    // this method call could cause a self-cleanup, and needs to really happen "last"
    // If the dialog has been closed, then we need to cancel the order to open it.
    // This happens in the case of a frictionless request, see webViewDidFinishLoad for details
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(showWebView)
                                               object:nil];
}

- (void)dismiss:(BOOL)animated {
    NSLog(@"dismiss");
    
    if (animated && _everShown) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}


#pragma mark - close button handler

- (void)cancel {
    NSLog(@"cancel");
    [self dismiss:YES];
}


#pragma mark - spinner

- (void)showSpinner {
    NSLog(@"show spinner");

    [_spinner sizeToFit];
    [_spinner startAnimating];
    _spinner.center = _webView.center;
}

- (void)hideSpinner {
    NSLog(@"hide spinner");
    [_spinner stopAnimating];
    _spinner.hidden = YES;
}


#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification*)notification {
    
    _showingKeyboard = YES;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _webView.frame = CGRectInset(_webView.frame,
                                     -(kPadding + kBorderWidth),
                                     -(kPadding + kBorderWidth));
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _showingKeyboard = NO;

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _webView.frame = CGRectInset(_webView.frame,
                                     kPadding + kBorderWidth,
                                     kPadding + kBorderWidth);
    }
}


#pragma mark - notifications

- (void)addObservers {
    NSLog(@"add observers");

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
    NSLog(@"remove observers");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}


#pragma mark - utils

- (void)deviceOrientationDidChange:(void*)object {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (!_showingKeyboard && [self shouldRotateToOrientation:orientation]) {
        [self updateWebOrientation];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scale_factor = 1.0f;
    
    CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
    CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (void)updateWebOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.setAttribute('orientation', 90);"];
    } else {
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.removeAttribute('orientation');"];
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}



#pragma mark - UI methods

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    
    if (radius == 0) {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddRect(context, rect);
    } else {
        rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
        CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    }
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    if (fillColors) {
        CGContextSaveGState(context);
        CGContextSetFillColor(context, fillColors);
        if (radius) {
            [self addRoundedRectToPath:context rect:rect radius:radius];
            CGContextFillPath(context);
        } else {
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    
    CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorSpace(context, space);
    CGContextSetStrokeColor(context, strokeColor);
    CGContextSetLineWidth(context, 1.0);
    
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y-0.5},
            {rect.origin.x+rect.size.width, rect.origin.y-0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5},
            {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+rect.size.width-0.5, rect.origin.y},
            {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
            {rect.origin.x+0.5, rect.origin.y+rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(space);
}

@end
