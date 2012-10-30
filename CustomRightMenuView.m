//
//  CustomRightMenuView.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-31.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "CustomRightMenuView.h"
static NSMutableDictionary *allTypes;
@implementation CustomRightMenuView
@synthesize categoryArrayArray;
@synthesize buttonDirects;
@synthesize mainView;

+(NSMutableDictionary*) getAllTypes{//所有类型
    if(allTypes==nil){
        allTypes=[[NSMutableDictionary alloc]init];//所有类型
        [allTypes setObject:@"景点" forKey:@"attraction"];
        [allTypes setObject:@"餐厅" forKey:@"restaurant"];
        [allTypes setObject:@"购物" forKey:@"shoppingcenter"];
        [allTypes setObject:@"地铁" forKey:@"subway"];
        [allTypes setObject:@"火车" forKey:@"railway"];
        [allTypes setObject:@"机场" forKey:@"airport"];
        [allTypes setObject:@"维基" forKey:@"wikipedia"];
    }
    return allTypes;
}

//@synthesize listArray;
//@synthesize listImageArray;
- (id)initWithFrame:(CGRect)frame{
    NSMutableDictionary *allTypes=[CustomRightMenuView getAllTypes];
    
    
    NSString *sql =@"SELECT category  FROM poi GROUP BY category order by count(category) desc";// 获得数据库里的类型
    
    NSMutableArray *listArray=[[NSMutableArray alloc]init];//中文类型
    categoryArrayArray=[[NSMutableArray alloc]init];//英文类型
    [listArray addObject:@"筛选地点"];
    [listArray addObject:@"全部"];
    [categoryArrayArray addObject:@"op"];
    [categoryArrayArray addObject:@"all"];
    
    
    bool isHavewikipedia =NO;//是否含有维基百科  最后显示
    FMDatabase *db= [ViewController getDataBase];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
    while ([resultSet next]) {
        NSString *nc =[resultSet stringForColumn:@"category"];
        NSLog(nc);
        if([nc isEqualToString:@"wikipedia"]){
            isHavewikipedia =YES;
        }else{
            NSString *nValue=[allTypes objectForKey:nc];
            if(nValue!=nil){
                [listArray addObject:nValue];
                [categoryArrayArray addObject:nc];
            }
        }
    }
    
    if(isHavewikipedia){//最后添加维基
        [listArray addObject:[allTypes objectForKey:@"wikipedia"]];
        [categoryArrayArray addObject:@"wikipedia"];
    }
    
    
    [resultSet close];
    [db close];
    
    
  //  NSArray *listArray=[[NSArray alloc]initWithObjects:@"筛选地点",@"全部",@"景点",@"地铁",@"餐厅",@"购物", nil];
   // NSArray *listImageArray=[[NSArray alloc]initWithObjects:@"listop",@"listall",@"listjingdian",@"listsubway",@"listiconcanting",@"listgouwu", nil];
  //  categoryArrayArray=[[NSArray alloc]initWithObjects:@"筛选地点",@"全部",@"attraction",@"subway",@"restaurant",@"shoppingcenter", nil];
    
    
    return [self initWithFrame:frame nameArray:listArray imageArray:nil categoryArray:categoryArrayArray];
}


- (id)initWithFrame:(CGRect)frame nameArray:(NSArray *)listArray imageArray:(NSArray *)listImageArray categoryArray:(NSArray *)categoryArray
{
   // [self setCategoryArrayArray:categoryArray];
    //    景点: attraction
    //    餐厅: restaurant
    //    购物: shoppingcenter
    //    地铁: subway
    //    火车: railway
    //    机场：airport
    //    维基： wikipedia
    
     buttonDirects =[[NSMutableDictionary alloc]init];
    //listop
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"listfiterbg"]]];
        
        for (int i=0;i<listArray.count;i++) {
            NSString *listName =[listArray objectAtIndex:i];
            NSString *listImage=[[NSString alloc]initWithFormat:@"list%@",[categoryArray objectAtIndex:i]];//[listImageArray objectAtIndex:i];
            
           
            
            
            UIView *subView=[[UIView alloc] initWithFrame:CGRectMake(0, 55*i-15, frame.size.width, 55)];
            
            RightMenuButton *rightBut =[RightMenuButton buttonWithType: UIButtonTypeCustom];
            [rightBut setWithFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height) listImageName:listImage listName:listName];
            [rightBut setButtonName:listImage];
             
            if(i==0){
                [rightBut titleIsUnableSelect];
            }else{
                [rightBut addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
            }
            [rightBut setCategoryName:[categoryArray objectAtIndex:i]];
            [rightBut setTag:i];
           // [rightBut setBackgroundColor:[UIColor redColor]];
            
            UIImageView *listlineImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listline"]];
            [listlineImage setFrame:CGRectMake(0, 55, listlineImage.frame.size.width, listlineImage.frame.size.height)];

            [subView addSubview:listlineImage];
            [subView addSubview:rightBut];
            [self addSubview:subView];
            
            [buttonDirects setValue:rightBut forKey:listImage];
        }
        [self allSelectButtonISselect:YES];
    }
    return self;
}
-(void)selectMenu:(id)sender{
    if(![sender isSelected]){//点击按钮被选中
        NSLog(@"[sender buttonName]========-------%@",[sender buttonName]);
        if([[sender buttonName] isEqualToString:@"listall"]){
            [self allSelectButtonISselect:YES];
        }else{
            [self allSelectButtonISselect:NO];
            [sender isButtonSelect:YES];
        }
    }else{//点击按钮被取消
        [sender isButtonSelect:NO];
    }
    [self.delegate callbackClick:sender];
    
}

-(void)allSelectButtonISselect:(BOOL)select{
    if(select){//选中全部按钮
        for (id obj in buttonDirects) {
           //  NSLog([obj debugDescription]);
            if([obj isEqualToString:@"listall"]){
                [[buttonDirects valueForKey: obj] isButtonSelect:YES];
            }else{
                [[buttonDirects valueForKey:obj] isButtonSelect:NO];
            }
        }
    }else{//选中其它按钮
        [[buttonDirects valueForKey: @"listall"] isButtonSelect:NO];
    }
}

- (void)viewDidLoad
{
    buttonDirects =nil;
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    NSString *sender=theTimer.userInfo;
    if([sender isEqualToString:@"select"]){
        if(mainView.frame.origin.x<-120){
            [mainView setFrame:CGRectMake(-120, 0, mainView.frame.size.width, mainView.frame.size.height)];
            count=0;
            [self setFrame:CGRectMake(200, 0, self.frame.size.width,self.frame.size.height)];
        }else if(mainView.frame.origin.x>=-(120-offset)){
            [mainView setFrame:CGRectMake(mainView.frame.origin.x-count*offset, 0, mainView.frame.size.width,mainView.frame.size.height)];
            [self setFrame:CGRectMake(self.frame.origin.x-count*offset, 0, self.frame.size.width,self.frame.size.height)];
            count++;
        }else{
            [theTimer invalidate];
            theTimer=nil;
        }
    }else{
        if(mainView.frame.origin.x>0){
            [mainView setFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
            [theTimer invalidate];
            theTimer=nil;
            count=0;
        }else if(mainView.frame.origin.x<=-offset){
            [mainView setFrame:CGRectMake(mainView.frame.origin.x+count*offset, 0, mainView.frame.size.width, mainView.frame.size.height)];
            count++;
        }else{
            count=0;
            [theTimer invalidate];
            theTimer=nil;
        }
    }
}
-(void) setActionButton:(UIButton *)button{
   // super.actionButton = button;
    [button addTarget:self action:@selector(saixuanClick:) forControlEvents:UIControlEventTouchUpInside];
}

static int count=0;
static int offset=10;
- (void)saixuanClick:(id)sender {
    
    NSString *select=nil;
    
    if([sender isSelected]){
        select =@"unselect";
    }else{
        select =@"select";
    }
    
    NSTimeInterval timeInterval =0.01;
    //定时器
    NSTimer *showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                          target:self
                                                        selector:@selector(handleMaxShowTimer:)
                                                        userInfo:select
                                                         repeats:YES];
    [showTimer fire];
    
    [sender setSelected:![sender isSelected]];
}
@end
