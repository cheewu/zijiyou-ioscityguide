//
//  DetailButtonUIView.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-13.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "DetailButtonUIView.h"

@implementation DetailButtonUIView
@synthesize button;
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        button =[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *im=[UIImage imageNamed:imageName];
        image = [[UIImageView alloc] initWithImage:im];
        label = [[UILabel alloc]init];
        [label setText:text];
        
        NSLog(@"text.length=%d",text.length);
        if(text.length<10){
            [label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        }else{
            [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        }
        
        [image setFrame:CGRectMake(8,  (frame.size.height-im.size.height)/2, im.size.width, im.size.height)];
        
        int imtoff=15;
        if(text.length>2){
            imtoff=10;
        }
        
        [label setFrame:CGRectMake(im.size.width+imtoff, 0,frame.size.width, frame.size.height)];
        [label setBackgroundColor:[UIColor clearColor]];
       
        label.textColor=[[UIColor alloc]initWithRed:99/255.0f green:92/255.0f blue:77/255.0f alpha:1.0f];
       // NSLog(@"x=%f,y=%f,w=%f,h=%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
        [button setFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
        //[button setBackgroundColor:[UIColor redColor]];
        [self addSubview:(image)];
        [self addSubview:(label)];
        [self addSubview:(button)];
        [button setShowsTouchWhenHighlighted:YES];
        self.layer.borderWidth  = 1;
   
        self.layer.borderColor= [DetailButtonUIView getColorFromRed:180 Green:180 Blue:180 Alpha:255];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        [self.layer setBackgroundColor:[DetailButtonUIView getColorFromRed:255 Green:255 Blue:255 Alpha:255]];
        
    }
    return self;
}


+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha/255.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    
    return color;
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
