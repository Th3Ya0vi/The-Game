//
//  AimEditView.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 26.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AimEditView.h"

@implementation AimEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Hello!";
        [self addSubview:label];
        [label sizeToFit];
        
        label.frame = CGRectMake((self.frame.size.width-label.frame.size.width)/2, (self.frame.size.height-label.frame.size.height)/2, label.frame.size.width, label.frame.size.height);
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

@end
