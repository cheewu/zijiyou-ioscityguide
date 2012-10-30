//
//  PCRectButton.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-29.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PCRectButton.h"

@implementation PCRectButton
@synthesize button;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        button =[[UIButton alloc]init];
        UIImage *image = [UIImage imageNamed:@"sxbutton"];
        UIImage *imagedown = [UIImage imageNamed:@"sxbuttondown"];
        [button setBackgroundImage:imagedown forState:UIControlStateSelected];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        UILabel *label =[[UILabel alloc] init];
        label.text=text;
        [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        label.textColor=[UIColor whiteColor];
        [button setFrame:CGRectMake(0, 0, image.size.width,image.size.height)];
        [label setFrame:CGRectMake(9, 0, image.size.width,image.size.height-2)];
        [label setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:button];
        [self addSubview:label];
    }
    return self;
}



@end
