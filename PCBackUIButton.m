//
//  PCBackUIButton.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-29.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PCBackUIButton.h"

@implementation PCBackUIButton
@synthesize button;
- (id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
    if (self) {
        button =[[UIButton alloc]init];
        UIImage *image = [UIImage imageNamed:@"back"];
        UIImage *imagedown = [UIImage imageNamed:@"backdown"];
        [button setBackgroundImage:imagedown forState:UIControlStateSelected];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        
        UILabel *label =[[UILabel alloc] init];
        label.text=@"返回";
        [label setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
        label.textColor=[UIColor whiteColor];
        [button setFrame:CGRectMake(0, 0, image.size.width,image.size.height)];
        [label setFrame:CGRectMake(image.size.width/4+2, 0, image.size.width,image.size.height-2)];
        [label setBackgroundColor:[UIColor clearColor]];
    
        [self addSubview:button];
        [self addSubview:label];
        
    }
    return self;
}

@end
