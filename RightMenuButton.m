//
//  RightMenuButton.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-2.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "RightMenuButton.h"

@implementation RightMenuButton
@synthesize buttonName;
@synthesize listSelectImage;
@synthesize categoryName;
-(void)setWithFrame:(CGRect)frame listImageName:(NSString *)imageName listName:(NSString *)name
{
//    self = [super initWithFrame:frame];
//    if (self) {
        //UIButton *but =[UIButton buttonWithType: UIButtonTypeCustom];
        listi =[UIImage imageNamed:imageName];
        imview=[[UIImageView alloc] initWithImage:listi];
        tile = [[UILabel alloc] init];
        
        [tile setContentMode:UIViewContentModeCenter];
        [tile setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15]];
       
        [tile setTextColor:[UIColor whiteColor]];
        [imview setFrame:CGRectMake(13, 18, listi.size.width, listi.size.height)];
            [tile setFrame:CGRectMake(45, 6, 80, 50)];
        self.showsTouchWhenHighlighted = YES;
            
            
        listSelectImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listselect"]];
        [listSelectImage setFrame:CGRectMake(85, 18, listSelectImage.frame.size.width, listSelectImage.frame.size.height)];
        [listSelectImage setHidden:YES];
        [self addSubview:listSelectImage];
        
        [tile setBackgroundColor:[UIColor clearColor]];
        [tile setText:name];
        [self addSubview:tile];
        [self addSubview:imview];
        [self setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    }
//    return self;
}
-(void) titleIsUnableSelect{
     self.showsTouchWhenHighlighted = NO;
    [tile setTextColor:[UIColor grayColor]];
    [tile setFrame:CGRectMake(41, 6, 80, 50)];
    [imview setFrame:CGRectMake(15, 18, listi.size.width, listi.size.height)];
}
-(void) isButtonSelect:(BOOL)select{
    [self setSelected:select];
    [listSelectImage setHidden:!select];
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
