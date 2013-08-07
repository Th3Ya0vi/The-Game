//
//  RootWizardViewController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "RootWizardViewController.h"
#import "AimObjectsManager.h"

@implementation UINavigationBar (customNav)
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(self.frame.size.width,50);
    return newSize;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIButton class]])   {
            float centerY = self.bounds.size.height / 2.0f;
            CGPoint center = view.center;
            center.y = centerY;
            view.center = center;
        }
        else if([view isKindOfClass:[UILabel class]])
        {
            float centerY = self.bounds.size.height / 2.0f;
            float centerX = self.bounds.size.width / 2.0f;
            CGPoint center = view.center;
            center.y = centerY;
            center.x = centerX;
            view.center = center;
        }
    }
}
@end

@interface UIBarButtonItem (BarButtonItemExtended)
+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;
@end

@implementation UIBarButtonItem (BarButtonItemExtended)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action
{
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton setImage:image forState:UIControlStateNormal];
    imgButton.frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
    
    UIBarButtonItem *b = [[UIBarButtonItem alloc]initWithCustomView:imgButton];
    
    [imgButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [b setAction:action];
    [b setTarget:target];
    
    return b;
}
@end

@interface RootWizardViewController ()

@end

@implementation RootWizardViewController
{
    NSInteger pageIndex;
    UILabel *titleLabel;
}

@synthesize scrollContainerForAims;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[AimObjectsManager sharedInstance] setFileHandler:@"testtesttest.plist"])
        NSLog(@"Cache for aims wizard > 0");
    else
        NSLog(@"Cache for aims wizard = 0");
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *onNextPageButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"toolbar-proceed-icon-white@2x.png"] target:self action:@selector(onNextPage)];
    [self.navigationItem setRightBarButtonItem:onNextPageButton animated:YES];
    
    UIBarButtonItem *onCancelButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"toolbar-cancel-icon@2x.png"] target:self action:@selector(onCancel)];
    [onCancelButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:onCancelButton animated:YES];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    titleLabel.layer.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.5);
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    [self.navigationItem setTitleView: titleLabel];
    
    [self performSelector:@selector(initCode)];
}

-(void) viewDidDisappear:(BOOL)animated
{
    for(AimEditView *subview in self.scrollContainerForAims.subviews)
    {
        if([subview isKindOfClass:[AimEditView class]]) {
            [subview dissapearView];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) initCode
{
    pageIndex = 0;
    [self setAimTitle];
    
    for(int loop=0; loop<10; loop++)    {
        [self addAimPage:loop];
    }
}

-(void) setAimTitle
{
    titleLabel.text = [NSString stringWithFormat:@"%i из 10", pageIndex+1];
    [titleLabel sizeToFit];
}

-(void) addAimPage:(NSInteger)index
{
    AimEditView *aimPage = [[AimEditView alloc] initWithFrame:self.view.bounds];
    aimPage.delegate = (id)self;
    aimPage.frame = CGRectMake(index*aimPage.frame.size.width, aimPage.frame.origin.y, aimPage.frame.size.width, aimPage.frame.size.height);
    
    [aimPage setAimObject: [[AimObjectsManager sharedInstance] aimObjectByIndex:index]];
    
    scrollContainerForAims.contentSize = CGSizeMake( (index+1)*self.view.frame.size.width, self.view.bounds.size.height);
    [scrollContainerForAims addSubview:aimPage];
}

-(void) didChangeContextInView
{
    NSLog(@"1");
    [self performSelectorOnMainThread:@selector(saveAllDataToCache) withObject:nil waitUntilDone:NO];
}

#pragma mark -- Navigation controller buttons selectors
-(void) onNextPage
{
    pageIndex++;
    [self scrollToPage: pageIndex animated:YES];
}

-(void) saveAllDataToCache
{
    NSInteger loop = 0;
    for(AimEditView *subview in self.scrollContainerForAims.subviews)
    {
        if([subview isKindOfClass:[AimEditView class]]) {
            [self saveDataFromAimView: subview byIndex:loop++];
        }
    }
}

-(BOOL) saveDataFromAimView:(AimEditView*)aimView byIndex:(NSInteger)index
{
    return [[AimObjectsManager sharedInstance] addAimObject:[aimView aimObjectFromView] toIndex:index];
}

-(void) onCancel
{
    [self performSelectorOnMainThread:@selector(saveAllDataToCache) withObject:nil waitUntilDone:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    if (page <= 0) {
        page = 0;
        pageIndex = 0;
    } else if(page >= 9)    {
        page = 9;
        pageIndex = 9;
    }
    
    [scrollContainerForAims scrollRectToVisible:CGRectMake(page * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.bounds.size.height) animated:animated];
}

-(int) getCurrentDisplayedPage
{
    return floor(scrollContainerForAims.contentOffset.x/self.view.frame.size.width);
}

-(int) getXPositionOfPage:(NSInteger)page
{
    return page * self.view.frame.size.width;
}

-(AimEditView*) getViewByIndex:(NSInteger)index
{
    NSInteger loop = 0;
    for(AimEditView *subview in self.scrollContainerForAims.subviews)
    {
        if([subview isKindOfClass:[AimEditView class]]) {
            if(loop == index)
                return subview;
            loop++;
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = [self getCurrentDisplayedPage];
    
    pageIndex = currentPage;
    [self setAimTitle];
    
    double minimumZoom = 0.93;
    double zoomSpeed = 1000; //increase this number to slow down the zoom
    UIView *currentView = [scrollContainerForAims.subviews objectAtIndex:currentPage];
    UIView *nextView;
    if (currentPage < [scrollContainerForAims.subviews count]-1){
        nextView = [scrollContainerForAims.subviews objectAtIndex:currentPage+1];
    }
    
    //currentView zooms out as scroll left
    int distanceFromPageOrigin = scrollContainerForAims.contentOffset.x - [self getXPositionOfPage:currentPage]; //find out how far the scroll is away from the start of the page, and use this to adjust the transform of the currentView
    if (distanceFromPageOrigin < 0) {distanceFromPageOrigin = 0;}
    double scaleAmount = 1-(distanceFromPageOrigin/zoomSpeed);
    if (scaleAmount < minimumZoom ){scaleAmount = minimumZoom;}
    currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scaleAmount, scaleAmount);
    
    //nextView zooms in as scroll left
    if (nextView != nil){
        //find out how far the scroll is away from the start of the next page, and use this to adjust the transform of the nextView
        distanceFromPageOrigin = (scrollContainerForAims.contentOffset.x - [self getXPositionOfPage:currentPage+1]) * -1;//multiply by minus 1 to get the distance to the next page (because otherwise the result would be -300 for example, as in 300 away from the next page)
        if (distanceFromPageOrigin < 0) {distanceFromPageOrigin = 0;}
        scaleAmount = 1-(distanceFromPageOrigin/zoomSpeed);
        if (scaleAmount < minimumZoom ){scaleAmount = minimumZoom;}
        nextView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scaleAmount, scaleAmount);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [scrollView endEditing:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self performSelectorOnMainThread:@selector(saveAllDataToCache) withObject:nil waitUntilDone:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelectorOnMainThread:@selector(saveAllDataToCache) withObject:nil waitUntilDone:NO];
}

@end