//
//  ListViewBox.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-24.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "ListViewBox.h"
#import <objc/runtime.h>

@implementation ListViewBox
@synthesize displayTextLabel;
@synthesize userImageView;
@synthesize lineId;
@synthesize poiData;

- (id)initWithFrame:(CGRect)frame imgURL:(NSString *)imgurl textColor:(NSString *)textColor text:(NSString *)text
{
    return [self initWithFrame:frame imgURL:imgurl textColor:textColor text:text stationText:nil leftImage:nil];
}
- (id)initWithFrame:(CGRect)frame imgURL:(NSString *)imgurl textColor:(NSString *)textColor text:(NSString *)text stationText:(NSString *)stationText leftImage:(NSString *)image{
     return [self initWithFrame:frame imgURL:imgurl textColor:textColor text:text stationText:stationText leftImage:image sandetName:nil];
}
- (id)initWithFrame:(CGRect)frame imgURL:(NSString *)imgurl textColor:(NSString *)textColor text:(NSString *)text stationText:(NSString *)stationText leftImage:(NSString *)image sandetName:(NSString *)sandetName
{
    
    if(![textColor hasPrefix:@"#"]){
        textColor = [[NSString alloc] initWithFormat:@"%@%@",@"#",textColor];
    }
    self = [super initWithFrame:frame];
    if (self) {
        //   [self setBackgroundColor:[UIColor whiteColor]];
       // [self setFrame:CGRectMake(50,50, 200, 100)];
        self.layer.cornerRadius = 4;
        self.layer.borderColor =[[UIColor grayColor] CGColor];
		self.layer.borderWidth = 0.5;
        
        //self.layer.shadowColor = [UIColor blackColor].CGColor;
        //self.layer.shadowOffset = CGSizeMake(1, 1);
       // self.layer.shadowOpacity = 0.5;
       // self.layer.shadowRadius = 0.5;
		[self setBackgroundColor:RGBACOLOR(255,255,255,1)];
        
		
		_userImageView = [[UIImageView alloc] init];
		[_userImageView setBackgroundColor:[UIColor clearColor]];
		_userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
		_userImageView.layer.borderWidth = 2;
        UIImage *imge= [UIImage imageNamed:imgurl];
		[_userImageView setImage:imge];
        [_userImageView setFrame:CGRectMake(self.frame.size.width- imge.size.width-3, (self.frame.size.height- imge.size.height)/2, imge.size.width, imge.size.height)];
		[self addSubview:_userImageView];
        
        if(image==nil){
            UIView *textUIView=[[UIView alloc]init];
            
            
            
            [textUIView setBackgroundColor:[ViewController hexStringToColor:textColor]];
          //  textUIView.layer.cornerRadius = 5;
                    
            _displayTextLabel = [[UILabel alloc] init];
            [_displayTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [_displayTextLabel setLineBreakMode:UILineBreakModeTailTruncation];
            [_displayTextLabel setContentMode:UIViewContentModeCenter];
            [_displayTextLabel setTextColor:[UIColor whiteColor]];
            [_displayTextLabel setBackgroundColor:[UIColor clearColor]];
            [_displayTextLabel setText:text];
            CGSize size = [_displayTextLabel.text sizeWithFont:_displayTextLabel.font constrainedToSize:CGSizeMake(200.0f, 50.0f) lineBreakMode:UILineBreakModeWordWrap];

            [_displayTextLabel setFrame:CGRectMake(7.5, 0, size.width+10,self.frame.size.height-10)];
            [textUIView setFrame:CGRectMake(10,7,size.width+15,self.frame.size.height-12.5)];
            
            [textUIView addSubview:_displayTextLabel];
            [self addSubview:textUIView];
        }else{
            UIImage *imge= [UIImage imageNamed:image];
            UIImageView *leftImageView=[[UIImageView alloc] initWithImage:imge];
            [leftImageView setContentMode:UIViewContentModeCenter];
            [leftImageView setFrame:CGRectMake(0,0, 80, self.frame.size.height)];
            [self addSubview:leftImageView];
        }
        if(stationText!=nil){
            UILabel *_stationTextLabel = [[UILabel alloc] init];
            //[_stationTextLabel setContentMode:UIViewContentModeCenter];
            [_stationTextLabel setTextColor:RGBACOLOR(64,64,64,1)];
            [_stationTextLabel setBackgroundColor:[UIColor clearColor]];
            [_stationTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [_stationTextLabel setText:stationText];
            [_stationTextLabel setFrame:CGRectMake(100, 0, 200,self.frame.size.height)];
            [self addSubview:_stationTextLabel];
        }
        if(sandetName!=nil){
            UILabel *_sandetNameTextLabel = [[UILabel alloc] init];
            [_sandetNameTextLabel setTextColor:RGBACOLOR(64,64,64,1)];
            [_sandetNameTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [_sandetNameTextLabel setBackgroundColor:[UIColor clearColor]];
            [_sandetNameTextLabel setText:sandetName];
            [_sandetNameTextLabel setFrame:CGRectMake(100, 0, 200,self.frame.size.height)];
            [self addSubview:_sandetNameTextLabel];
        }
    }
    return self;
}


static char kWhenTouchedUpBlockKey;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)whenTouchedUp:(JMWhenTappedBlock)block {
    [self  setBlock:block forKey:&kWhenTouchedUpBlockKey];
}
- (void)setBlock:(JMWhenTappedBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)runBlockForKey:(void *)blockKey {
    JMWhenTappedBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block();
}


@end
