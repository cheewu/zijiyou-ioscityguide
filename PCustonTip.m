//
//  PCustonTip.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-30.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PCustonTip.h"

@implementation PCustonTip

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label=[[UILabel alloc] init];
        label.text=@"testasetat";
        label.frame =frame;
        [self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
