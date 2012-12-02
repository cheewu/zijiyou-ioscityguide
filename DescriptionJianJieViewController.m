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
@synthesize tableView = _tableView;
@synthesize headViewArray;

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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-10, 0,340,460) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    
    
    
    NSData *jsonData = [textDate dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArray =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
  //  NSLog(textDate);
    int offy=60;
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, offy, 320, 500)];
    for (id dataValue in dataArray) {//所有种类
      //  NSLog(dataValue);
        if([dataValue isKindOfClass:[NSDictionary class]]){//每条数据 字典
            for (NSString *valueKey in [dataValue allKeys]) {
                id valuedata = [dataValue objectForKey:valueKey];
                if([valuedata isKindOfClass:[NSString class]] && [valueKey isEqualToString:@"General"]){//只含一个
                    UILabel *generallabel =[self getUILabel:valuedata offy:0];
                    [scrollView addSubview:generallabel];
                    offy+=generallabel.frame.size.height;
                }else if([valuedata isKindOfClass:[NSArray class]]){//包含多个
                    NSLog(@"type---------%@",valueKey);//所有分类的名字
                    
                    NSMutableString *descString=[[NSMutableString alloc]init];
                    for (id descDictionary in valuedata) {
                        for (NSString *vKey in [descDictionary allKeys]) {
                            [descString appendFormat:@"%@:%@\n",vKey,descDictionary[vKey]];
                        }
                    }
                    NSLog(descString);
                }
//                    for (NSDictionary *descDictionary in valuedata) {
//                            for (NSString *vKey in [dataValue allKeys]) {
//                                NSLog(vKey);
//                                NSLog([dataValue objectForKey:vKey]);
//                            }
//                    }
//                }
            }
        }
//        else if([dataValue isKindOfClass:[NSArray class]]){
//            for (id dataValue in dataArray) {
//                NSLog(dataValue);
//            }
//        }
       
        
        
//          id valueString = [dataDictionary objectForKey:jkey];
//            if([valueString isKindOfClass:[NSString class]]){
//                if(jkey!=nil && [jkey isEqualToString:@"General"]){
//                    UILabel *generallabel =[self getUILabel:valueString offy:0];
//                    [scrollView addSubview:generallabel];
//                    offy+=generallabel.frame.size.height;
//                }
//            }else{
//                UIView *titleView= [self getTitleUILabel:jkey rect:CGRectMake(0, offy, 320, 60)];
//                [scrollView addSubview:titleView];
//                offy+=titleView.frame.size.height;
        
//                for (id jkey in valueString){
//                        offy+=10;
//                        UIView *titleView= [self getTitleUILabel:jkey rect:CGRectMake(0, offy, 320, 60)];
//                        [scrollView addSubview:titleView];
//                        offy+=titleView.frame.size.height;
//                        
//                    }
//                }
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


#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?45:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.headViewArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HeadView* headView = [self.headViewArray objectAtIndex:section];
    return headView.open?5:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headViewArray count];
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        UIButton* backBtn=  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 340, 45)];
        backBtn.tag = 20000;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
        backBtn.userInteractionEnabled = NO;
        [cell.contentView addSubview:backBtn];
        
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 340, 1)];
        line.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:line];
        
    }
    UIButton* backBtn = (UIButton*)[cell.contentView viewWithTag:20000];
    HeadView* view = [self.headViewArray objectAtIndex:indexPath.section];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_2_nomal"] forState:UIControlStateNormal];
    
    if (view.open) {
        if (indexPath.row == _currentRow) {
            [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
        }
    }
    
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRow = indexPath.row;
    [_tableView reloadData];
}


#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view{
    _currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[headViewArray count];i++)
        {
            HeadView *head = [headViewArray objectAtIndex:i];
            head.open = NO;
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[headViewArray count];i++)
    {
        HeadView *head = [headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
            
        }else {
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
            
            head.open = NO;
        }
        
    }
    [_tableView reloadData];
}

@end
