//
//  PCTOPUIview.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-29.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PCTOPUIview.h"
#import "PCBackUIButton.h"
#import "PCRectButton.h"

@implementation PCTOPUIview
@synthesize button;
@synthesize rightButton;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title backTitle:(NSString *)backTitle righTitle:(NSString *)righTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:frame];
        UIImage *image = [UIImage imageNamed:@"navetionbag"];
        [imageView setBackgroundColor:[UIColor colorWithPatternImage:image]];
      //  [imageView setImage:image];
        [self addSubview:imageView];

        if(backTitle!=nil){
            PCBackUIButton *backb=[[PCBackUIButton alloc]init];
            [backb setFrame:CGRectMake(5, 8, 56, 36)];
            [self addSubview:backb];
            button = backb.button;
        }
        if(righTitle!=nil){
            PCRectButton *pcr=[[PCRectButton alloc] initWithFrame:CGRectMake(260, 8, 56, 36) text:righTitle];
            [self addSubview:pcr];
            rightButton = pcr.button;
        }
        
        
        UILabel *label =[[UILabel alloc] init];
        label.text=title;
        [label setFont:[UIFont fontWithName:@"Heiti SC" size:18]];
        label.textColor=[UIColor whiteColor];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFrame:self.frame];
        [label setTextAlignment:UITextAlignmentCenter];
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
