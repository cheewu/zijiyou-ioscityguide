//
//  PCustButton.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-21.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PCustButtonController.h"

@implementation PCustButtonController
@synthesize button;
@synthesize type;
@synthesize text;
@synthesize typeString;

- (id)initWithFrame:(CGRect)frame typeImageName:(NSString *)typeName textString:(NSString *)textString{

    id obj= [super initWithFrame:frame];
    typeString=typeName;
    text = [[UILabel alloc] init];
    text.text=textString;
    [self addCustomElements];
    return  obj;
}
-(void)addCustomElements
{
    [self setBackgroundColor:[UIColor whiteColor]];
    NSInteger left =30;
    UIImage *arrow = [UIImage imageNamed:@"arrows"];
    type= [UIImage imageNamed:typeString];
   // UIImage *butImages =[UIImage imageNamed:@"homebuttonnor"];

   //  [butImage stretchableImageWithLeftCapWidth:45 topCapHeight:0];
    UIImage *butImage= [[UIImage imageNamed:@"homebuttonnor"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    UIImage *butImagecl= [[UIImage imageNamed:@"homebuttonclick"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    [butImagecl stretchableImageWithLeftCapWidth:45 topCapHeight:0];
    
    
   // UIImageView *imagBg = [[UIImageView alloc] init];//initWithFrame:CGRectMake(0, 0 , 26, self.frame.size.height+2)];
   // imagBg.image=butImage;
    //imagBg.contentMode =UIViewContentModeScaleAspectFit;
   // [imagBg setFrame:self.frame];
   
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    button.showsTouchWhenHighlighted = YES;
   [button setBackgroundImage:butImage forState:UIControlStateNormal];
    
    [button setBackgroundImage:butImagecl forState:UIControlStateHighlighted];
 //   [button setContentMode:UIViewContentModeScaleToFill];
    
    
    
   
    
    UIImageView *imagViewType = [[UIImageView alloc] initWithFrame:CGRectMake(left, (self.frame.size.height-18)/2 , 18, 18)];
    imagViewType.image = type;
    imagViewType.contentMode=UIViewContentModeScaleAspectFit;
    
    UIImageView *imagViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-left+10, (self.frame.size.height-18)/2 , arrow.size.width, arrow.size.height)];
    imagViewArrow.image = arrow;
    imagViewArrow.contentMode=UIViewContentModeScaleAspectFit;
    
   // [text setOpaque:NO];
    text.backgroundColor=[UIColor clearColor];
    [text setFont:[UIFont fontWithName:@"Heiti Tc" size:16]];
    [text setFrame:CGRectMake(imagViewType.frame.size.width+45, 0 , self.frame.size.width, self.frame.size.height)];
    [text setTextAlignment:UITextAlignmentLeft];

    self.backgroundColor=[UIColor clearColor];
    
   // [self addSubview:imagBg];
    [self addSubview:button];
    [self addSubview:imagViewArrow];
    [self addSubview:imagViewType];
    [self addSubview:text];
   
}

@end
