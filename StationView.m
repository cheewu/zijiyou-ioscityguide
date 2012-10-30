//
//  StationView.m
//  自己游
//
//  Created by piaochunzhi on 12-9-25.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "StationView.h"

@implementation StationView
@synthesize poiData;
@synthesize poiStations;

- (id)initWithFrame:(CGRect)frame transferStations:(NSArray *)stations poiData:(NSDictionary *)poidata
{
    self = [super initWithFrame:frame];
    if (self) {
//        button = [UIButton buttonWithType: UIButtonTypeCustom];
//        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self setPoiData:poidata];
        [self setPoiStations:stations];
        self.layer.cornerRadius = 5;
        self.layer.borderColor =[[UIColor grayColor] CGColor];
		self.layer.borderWidth = 0.5;

		[self setBackgroundColor:RGBACOLOR(255,255,255,1)];
        
		
		_userImageView = [[UIImageView alloc] init];
		[_userImageView setBackgroundColor:[UIColor clearColor]];
		_userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
		_userImageView.layer.borderWidth = 2;
        UIImage *imge= [UIImage imageNamed:@"arrows"];
		[_userImageView setImage:imge];
        [_userImageView setFrame:CGRectMake(self.frame.size.width- imge.size.width-3, (self.frame.size.height- imge.size.height)/2, imge.size.width, imge.size.height)];
		[self addSubview:_userImageView];
        NSString *dis =[[poiData objectForKey:@"dis"] stringValue];

        NSRange rang = [dis rangeOfString:@"."];
        if(rang.length>0){
            dis = [dis substringToIndex:rang.location];
        }
        
        NSString *text =[poiData objectForKey:@"name"];
        UILabel *textLabel = [[UILabel alloc] init];
        [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [textLabel setTextColor:RGBACOLOR(65,65,65,1)];
        [textLabel setText:text];
         CGSize textLabelSize = [textLabel.text sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(200.0f, 50.0f) lineBreakMode:UILineBreakModeWordWrap];
         int offx=80;
        [textLabel setFrame:CGRectMake(10, 0, textLabelSize.width, frame.size.height)];
//        [textLabel setFrame:CGRectMake(10,2, textLabelSize.width, frame.size.height-30)];

        if(dis!=nil){
            UILabel *disLabel = [[UILabel alloc] init];
            
          //  [disLabel setTextColor:RGBACOLOR(65,65,65,1)];
            [disLabel setText:[[NSString alloc] initWithFormat:@"(%@m)",dis]];
            [disLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
            [disLabel setContentMode:UIViewContentModeCenter];
            [disLabel setLineBreakMode:UILineBreakModeTailTruncation];
          //  disLabel.adjustsFontSizeToFitWidth = NO;
           // disLabel.minimumFontSize = 10.0;
            CGSize size = [disLabel.text sizeWithFont:disLabel.font constrainedToSize:CGSizeMake(200.0f, 50.0f) lineBreakMode:UILineBreakModeWordWrap];
            
            [disLabel setFrame:CGRectMake(textLabel.frame.origin.x+ textLabel.frame.size.width+3,(frame.size.height-size.height)/2, size.width, size.height)];
            [self addSubview:disLabel];
            
            offx+=32;
        }
        if(stations!=nil&&stations.count>0){
           
            for (NSDictionary *sta in stations) {
                double offw=0;
                NSString *textColor =[sta objectForKey:@"color"];
                NSString *textLine =[sta objectForKey:@"linename"];
                
                UIView *textUIView=[[UIView alloc]init];//填充地铁站
                [textUIView setBackgroundColor:[ViewController hexStringToColor:textColor]];
                //textUIView.layer.cornerRadius = 4;
                
                _displayTextLabel = [[UILabel alloc] init];
                [_displayTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
               // [_displayTextLabel setFont:[UIFont fontWithName:@"STHeitiSC" size:15]];
                [_displayTextLabel setLineBreakMode:UILineBreakModeTailTruncation];
                [_displayTextLabel setContentMode:UIViewContentModeCenter];
                [_displayTextLabel setTextColor:[UIColor whiteColor]];
                [_displayTextLabel setBackgroundColor:[UIColor clearColor]];
                [_displayTextLabel setText:textLine];
                CGSize size = [_displayTextLabel.text sizeWithFont:_displayTextLabel.font constrainedToSize:CGSizeMake(200.0f, 50.0f) lineBreakMode:UILineBreakModeWordWrap];
               // [textLabel setFrame:CGRectMake(10,2, textLabelSize.width, frame.size.height-30)];
                [_displayTextLabel setFrame:CGRectMake(5, 0, size.width+10,20)];
                
                offw+=size.width+10;
                [textUIView setFrame:CGRectMake(offx,(frame.size.height-20)/2,offw,20)];
                offw+=10;
                [textUIView addSubview:_displayTextLabel];
                [self addSubview:textUIView];
                offx+=textUIView.frame.size.width+5;
            }
        }
//        else{
//            [textLabel setFrame:CGRectMake(10, 0, textLabelSize.width, frame.size.height)];
//        }
        
        
//        [self addSubview:button];
        [self addSubview:textLabel];
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
