//
//  RootWizardViewController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "RootWizardViewController.h"
#import "AimEditView.h"

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
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *onNextPageButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(onNextPage)];
    [self.navigationItem setRightBarButtonItem:onNextPageButton animated:YES];
    
    UIBarButtonItem *onCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"x" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:onCancelButton animated:YES];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
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
    aimPage.frame = CGRectMake(index*aimPage.frame.size.width, aimPage.frame.origin.y, aimPage.frame.size.width, aimPage.frame.size.height);
    
    scrollContainerForAims.contentSize = CGSizeMake( (index+1)*self.view.frame.size.width, self.view.bounds.size.height);
    [scrollContainerForAims addSubview:aimPage];
}

#pragma mark -- Navigation controller buttons selectors
-(void) onNextPage
{
    pageIndex++;
    [self scrollToPage: pageIndex animated:YES];
}

-(void) onCancel
{
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

@end