//
//  PCustAButtonView.m
//  zijiyoun
//
//  Created by piaochunzhi on 12-9-18.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PCustAButtonView.h"

@implementation PCustAButtonView
@synthesize button;
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)image text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth  = 1;
        self.layer.borderColor= [[[UIColor alloc]initWithRed:201/255.0f green:201/255.0f blue:175/255.0f alpha:1.0f] CGColor];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor:[[UIColor alloc]initWithRed:233/255.0f green:231/255.0f blue:202/255.0f alpha:1.0f]];
        button=[UIButton buttonWithType: UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button setShowsTouchWhenHighlighted:YES];
        UIImageView *imgeView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        [imgeView setFrame:CGRectMake(10, 5, 20, 20)];
        
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(13+imgeView.frame.size.width, 0, 80, frame.size.height)];
        [label setText:text];
        [label setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:15]];
        label.textColor=[[UIColor alloc]initWithRed:97/255.0f green:90/255.0f blue:75/255.0f alpha:1.0f];
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:imgeView];
        [self addSubview:label];
        
        [self addSubview:button];
    }
    return self;
}

-(void) isSelect:(BOOL)select{
    if(select){
        self.layer.borderWidth  = 1;
        self.layer.borderColor= [[[UIColor alloc]initWithRed:201/255.0f green:201/255.0f blue:175/255.0f alpha:1.0f] CGColor];
        [self setBackgroundColor:[[UIColor alloc]initWithRed:233/255.0f green:231/255.0f blue:202/255.0f alpha:1.0f]];
        
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        
    }else{
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.borderWidth  = 0;
        [self.layer setBackgroundColor:(__bridge CGColorRef)([UIColor clearColor])];
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
    }
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
