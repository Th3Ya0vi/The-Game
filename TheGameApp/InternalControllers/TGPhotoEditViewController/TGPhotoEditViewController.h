//
//  TGPhotoEditViewController.h
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

@protocol TGPhotoEditViewControllerDelegate <NSObject>
-(void) addDataFromPhotoEdit:(ALAsset*)asset;
@end

@interface TGPhotoEditViewController : UIViewController

@property (nonatomic, retain) id<TGPhotoEditViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage *)aImage;
- (id)initWithDictionary:(NSDictionary *)info;

@end
