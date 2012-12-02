//
//  DescriptionJianJieViewController.m
//  zijiyou-ioscityguide
//
//  Created by piaochunzhi on 12-12-1.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "DescriptionJianJieViewController.h"

@interface DescriptionJianJieViewController ()

@end

@implementation DescriptionJianJieViewController
@synthesize textDate;
@synthesize textTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:textTitle backTitle:@"" righTitle:nil];
    [self.view addSubview: pctop];
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    NSData* jsonData = [textDate dataUsingEncoding:NSUTF8StringEncoding];
    id jsonDescription =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    int offy=60;
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, offy, 320, 500)];
    for (id jkey in jsonDescription) {
          id valueString = [jsonDescription objectForKey:jkey];
            if([valueString isKindOfClass:[NSString class]]){
                if(jkey!=nil && [jkey isEqualToString:@"General"]){
                    UILabel *generallabel =[self getUILabel:valueString offy:0];
                    [scrollView addSubview:generallabel];
                    offy+=generallabel.frame.size.height;
                }
            }else{
                UIView *titleView= [self getTitleUILabel:jkey rect:CGRectMake(0, offy, 320, 60)];
                [scrollView addSubview:titleView];
                offy+=titleView.frame.size.height;
                
//                for (id jkey in valueString){
//                        offy+=10;
//                        UIView *titleView= [self getTitleUILabel:jkey rect:CGRectMake(0, offy, 320, 60)];
//                        [scrollView addSubview:titleView];
//                        offy+=titleView.frame.size.height;
//                        
//                    }
                }
    }
    
    
    
    
    [self.view addSubview:scrollView];
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    
    
     [scrollView setContentSize:CGSizeMake(320,offy)];
	// Do any additional setup after loading the view.
}
-(UIView *)getTitleUILabel:(NSString *)text rect:(CGRect) rect{
    UIView *retView=[[UIView alloc]initWithFrame:rect];

    //初始化label
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
  
    UIFont *font = [UIFont fontWithName:@"Verdana" size:18];
   // UIColor *textColor=[[UIColor alloc]initWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f];
   
    [labelTitle setFrame:CGRectMake(5, 5, 320, 50)];
    labelTitle.text=text;
    labelTitle.font = font;
   // [labelTitle setTextColor:textColor];
    labelTitle.backgroundColor=[UIColor clearColor];

    UIImageView *imagView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowdown"]];
    [imagView setFrame:CGRectMake(280, 0, imagView.frame.size.width, imagView.frame.size.height)];
    
    [retView addSubview:labelTitle];
    return retView;
}

-(UILabel *)getUILabel:(NSString *)text offy:(CGFloat) offy{
    //初始化label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //设置自动行数与字符换行
    [label setNumberOfLines:0];
    label.lineBreakMode = UILineBreakModeWordWrap;
    UIFont *font = [UIFont fontWithName:@"Verdana" size:14];
    UIColor *textColor=[[UIColor alloc]initWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f];
    //设置一个行高上限
    CGSize size = CGSizeMake(300,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(10, offy, labelsize.width, labelsize.height)];
    label.text=text;
    label.font = font;
    [label setTextColor:textColor];
    label.backgroundColor=[UIColor clearColor];
    return label;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickBack{
    [self dismissModalViewControllerAnimated:YES];
}

@end
