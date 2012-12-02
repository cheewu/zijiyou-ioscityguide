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
    offy=50;
    if(textDate==nil &&textTitle==nil){
        textTitle=NSLocalizedStringFromTable(@"city_name", @"InfoPlist",nil);
        
        NSString *sql =@"select dvalue from citydescription  where dindex=1";
        FMDatabase *db= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
        //NSLog(@"sql====%@",sql);
        while ([resultSet next]) {
            textDate =[resultSet stringForColumn:@"dvalue"];
            // NSLog(@"name====%@",name);
        }
        
        [resultSet close];
        [db close];
    }
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:textTitle backTitle:@"" righTitle:nil];
    [self.view addSubview: pctop];
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, offy, 320, 500)];
    [self.view addSubview:scrollView];
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
   
    _contHight=-1;
    
    
    
    if(textDate==nil){
        return;
    }
    NSData *jsonData = [textDate dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArray =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
  //  NSLog(textDate);
       
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-10, 0,340,600) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled=NO;
    
    _currentRow = -1;
    headViewArray = [[NSMutableArray alloc]init ];

    int i=0;
    for (id dataValue in dataArray) {//所有种类
      //  NSLog(dataValue);
        if([dataValue isKindOfClass:[NSDictionary class]]){//每条数据 字典
            for (NSString *valueKey in [dataValue allKeys]) {
                id valuedata = [dataValue objectForKey:valueKey];
                if([valuedata isKindOfClass:[NSString class]] && [valueKey isEqualToString:@"General"]){//只含一个
                    UILabel *generallabel =[self getUILabel:valuedata offx:10 offy:0 font:[UIFont fontWithName:@"STHeitiSC-Light" size:14]];
                    [scrollView addSubview:generallabel];
                    generallabelHeight=generallabel.frame.size.height;
                    offy =generallabel.frame.size.height+10;
                    
                    
                }else if([valuedata isKindOfClass:[NSArray class]]){//包含多个
                   // NSLog(@"type---------%@",valueKey);//所有分类的名字
                    
                    HeadView* headview = [[HeadView alloc] init];
                    headview.delegate = self;
                    headview.section = i;
                    headview.titleLabel.text =valueKey;// 标题

                    i++;
                    
                    UIView *uView=[[UIView alloc]init];
                    NSInteger uioffy=0;
                //    NSMutableString *descString=[[NSMutableString alloc]init];
                    for (id descDictionary in valuedata) {
                        for (NSString *vKey in [descDictionary allKeys]) {
                            if(![vKey isEqualToString:@""]){
                                UILabel *keylabel= [self getUILabel:[[NSString alloc]initWithFormat:@"%@\n\n",vKey] offx:0 offy:uioffy font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16]];//副标题
                                [keylabel setTextColor:[UIColor blackColor]];
                                uioffy+=keylabel.frame.size.height;
                               // NSLog(@"uioffy=====%d",uioffy);
                                [uView addSubview:keylabel];
                            }
                           // [descString appendFormat:@"%@\n",descDictionary[vKey]];
      
                            UILabel *vlabel= [self getUILabel:[[NSString alloc]initWithFormat:@"%@\n",descDictionary[vKey]] offx:0 offy:uioffy font:[UIFont fontWithName:@"STHeitiSC-Light" size:14]];
                               // [descString appendFormat:@"%@\n\n%@\n",vKey,descDictionary[vKey]];
//                            }else{
//                                 [descString appendFormat:@"%@\n",descDictionary[vKey]];
//                            }
                            [uView addSubview:vlabel];
                            uioffy+=vlabel.frame.size.height;
                        }
                    }
                    [headview setContentUIView:uView];
                    [headview setContentUIViewHeight:uioffy];
                 //   headview.contentString = descString;
                    [self.headViewArray addObject:headview];
                    //NSLog(descString);
                }
            }
        }
    }
    [_tableView setFrame:CGRectMake(0, offy, 320, 600)];
    
    [scrollView addSubview:_tableView];
    
  //  [self loadModel];
    
   
    
    
    offy+=i*65;//_tableView.frame.size.height;
     [scrollView setContentSize:CGSizeMake(320,offy)];
	// Do any additional setup after loading the view.
}

//- (void)loadModel{
//    _currentRow = -1;
//    headViewArray = [[NSMutableArray alloc]init ];
//    for(int i = 0;i< 5 ;i++)
//	{
//		HeadView* headview = [[HeadView alloc] init];
//        headview.delegate = self;
//		headview.section = i;
//        [headview.backBtn setTitle:[NSString stringWithFormat:@"第%d组",i] forState:UIControlStateNormal];
//		[self.headViewArray addObject:headview];
//	}
//}



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



-(UILabel *)getUILabel:(NSString *)text offx:(CGFloat) offx offy:(CGFloat) offy font:(UIFont *)font{
    //初始化label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //设置自动行数与字符换行
    [label setNumberOfLines:0];
    label.lineBreakMode = UILineBreakModeWordWrap;
   // UIFont *font = [UIFont fontWithName:@"Verdana" size:14];
    UIColor *textColor=[[UIColor alloc]initWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f];
    //设置一个行高上限
    CGSize size = CGSizeMake(300,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(offx, offy, labelsize.width, labelsize.height)];
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
//    CGSize size = CGSizeMake(300,5000);
//    UIFont *font= [UIFont fontWithName:@"Arial" size:14.0];
//    CGSize labelsize = [headView.contentString sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
//    _contHight =labelsize.height;
    
     _contHight =headView.contentUIViewHeight;
    NSLog(@"heightForRowAtIndexPath===%d",_contHight);

    return headView.open?_contHight:0;
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
    if(headView.open){
        [headView.lineUIImageView setHidden:YES];
        [headView setOpenUIImageView:YES];
    }else{
        [headView.lineUIImageView setHidden:NO];
        [headView setOpenUIImageView:NO];
        
    }
    
    return headView.open?1:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headViewArray count];
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     HeadView* view = [self.headViewArray objectAtIndex:indexPath.section];
   NSLog(@"cellForRowAtIndexPath===%d",_contHight);
    
 //   static NSString *indentifier = @"cell";
 //   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
  //  if (!cell) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        UILabel *addressLabel=[[UILabel alloc]init];
//        [addressLabel setBackgroundColor:[UIColor clearColor]];
//       
//    //    moreLabel.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
//       // [[UIColor alloc]initWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:255] CGColor];
//
//        
//        [addressLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
//        addressLabel.textColor=[[UIColor alloc]initWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:255];
//        addressLabel.lineBreakMode = UILineBreakModeWordWrap;
//        addressLabel.numberOfLines = 0;
//        addressLabel.text = view.contentString;
//        
//        
//        
//        [cell setBackgroundView:addressLabel];
        //[cell.contentView addSubview:addressLabel];
        
  //  }
   [cell setBackgroundView:view.contentUIView];
   // UIButton* backBtn = (UIButton*)[cell.contentView viewWithTag:20000];
   
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_2_nomal"] forState:UIControlStateNormal];
//    
    if (view.open) {
        [scrollView setContentOffset:CGPointMake(0, generallabelHeight) animated:NO];
    }
//        if (indexPath.row == _currentRow) {
//            [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
//        }
//    }
//    
//    
//    
//    cell.textLabel.text = view.contentString;
   // cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor whiteColor];
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
            
           // [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [_tableView reloadData];

        
        return;
    }else{
        [view.lineUIImageView setHidden:NO];
        [view setOpenUIImageView:NO];
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
          //  [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
//            CGSize size = CGSizeMake(300,5000);
//            UIFont *font= [UIFont fontWithName:@"Arial" size:14.0];
//            CGSize labelsize = [head.contentString sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//            _contHight =labelsize.height;
             _contHight =head.contentUIViewHeight;
        }else {
            head.open = NO;
        }
        
    }
      NSLog(@"reset===%d",_contHight);
    
    
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _contHight+600)];
    
    [scrollView setContentSize:CGSizeMake(320, _contHight+600+generallabelHeight)];
    
    
    [_tableView reloadData];
}

@end
