//
//  SubWayUIView.m
//  zijiyou-ioscityguide
//
//  Created by piaochunzhi on 13-1-1.
//  Copyright (c) 2013年 piao chunzhi. All rights reserved.
//
#import "SubWayUIView.h"


@implementation SubWayUIView
@synthesize stationlistjson;
@synthesize offy;
@synthesize scrollView;
@synthesize subWayDrawViewController;
@synthesize color;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self drawRect:frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"color ======%@",[self color]);
    NSString *hexColor=[self color];
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
   // if([hexColor hasPrefix:@"#"]){
        hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    //}
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, red/255.0, green/255.0, blue/255.0, 1);
    CGContextSetRGBFillColor(context, red/255.0, green/255.0, blue/255.0, 1);
    offy=40;
    
    if([self stationlistjson]!=nil){
        NSData* jsonData = [stationlistjson dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* json =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        if(idSubDirs==nil){//所有换乘地铁线路数据
            idSubDirs= [[NSMutableDictionary alloc] init];
        }else{
            [idSubDirs removeAllObjects];
        }

        [SubWayHomeViewController getSubWayForJson:json jsonkey:@"transferLine" outDir:idSubDirs];//所有换乘地铁数据
        
        NSMutableString *poimongoids=[[NSMutableString alloc]initWithString:@""];//所有站的集合
        NSMutableDictionary *poimogoidesdsDic= [[NSMutableDictionary alloc]init];//加密对应的解密key为加密  value为解密
        NSMutableDictionary *poimogoidsDic= [[NSMutableDictionary alloc]init];//key为站名 值为换乘站集合 经过的线路
        for (NSDictionary *dic in json) {
            if([dic isKindOfClass:[NSDictionary class]]){
                //NSLog(@"idSubDirs count===%d",[idSubDirs count]);
                
                for (NSString *dicsub in dic) {//所有线路
                    NSArray *listSubWays =[dic objectForKey:dicsub];
                    
                    for(NSDictionary *dicSubWays in listSubWays){//一段的所有站
                        
                        NSString *poimongoides=[dicSubWays objectForKey:@"poimongoid"];
                        //  NSLog(@"poimongoides===%@",poimongoides);
                        
                        NSString* poimongoid =[NSDataDES getContentByHexAndDes:poimongoides key:deskey];
                        [poimogoidesdsDic setValue:poimongoid forKey:poimongoides];
                        
                        [poimongoids appendString:@"\""];
                        [poimongoids appendString:poimongoid];
                        [poimongoids appendString:@"\""];
                        [poimongoids appendString:@","];
                        
                        NSArray*trline= [dicSubWays objectForKey:@"transferLine"];
                        
                        NSMutableArray *trlineArray = [[NSMutableArray alloc]init];
                        for (id tr in trline) {
                            //     NSLog(@"===%@",tr);
                            [trlineArray addObject:[idSubDirs objectForKey:[[NSString alloc] initWithFormat:@"%@",tr]]];
                        }
                        [poimogoidsDic setObject:trlineArray forKey:poimongoid];
                    }
                }
            }
        }
        
        NSString *sqlpois;//所有地铁站点数据
        if(poimongoids.length>0){
            sqlpois=[poimongoids substringToIndex:poimongoids.length-1];
        }
        NSMutableArray *entries=[[NSMutableArray alloc]init];//所有地铁站点数据
        NSString *sql =[[NSString alloc]initWithFormat:@"SELECT * FROM poi where poimongoid in(%@)",sqlpois];//查找所有站点数据
        //  NSLog(@"sql===%@",sql);
        
        FMDatabase *db= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
        CLLocationCoordinate2D coord;
        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:entries setAllData:nil];
        [resultSet close];
        [db close];
        NSMutableDictionary *poiDics= [[NSMutableDictionary alloc]init];//所有经过的线路poi
        for (NSDictionary *poi in entries) {
            [poiDics setObject:poi forKey:[poi objectForKey:@"poimongoid"]];
        }
        
        int offx =80;
        int stationWidth=30;//起始站的宽度
        int stationHeight=50;//站站之间高度
        NSString *lastStationLineId;//最后站点匹配
        NSString *lastStationName;//最后站点匹配
        NSString *firstStationLineId;//第一个站点匹配
        
        CGPoint lastStationPoint=CGPointMake(-1, -1);
        NSArray *lastSecondLine;//倒数第二站
        int linei=0;
        int lineicount=[json count];
        for (NSDictionary *dic in json) {//所有线路
            if([dic isKindOfClass:[NSDictionary class]]){    
                for (NSString *dicsub in dic) {//遍历所有线路
                    NSArray *listSubWays =[dic objectForKey:dicsub];
                   // NSLog(@"dicsub===%@",dicsub);//线路名称
                    //bool drawStart=false;
                    int i=0;
                    int count=[listSubWays count];
                    NSMutableArray *listSubWaysCopy =[[NSMutableArray alloc]init];
                    bool isLastStationToNest=false;//判断最后一个站是不是与下一个站有关联
                    bool isDrawFirst=true;
                    for(NSDictionary *dicSubWays in listSubWays){//一段的所有站
                        NSString *poimongoides=[dicSubWays objectForKey:@"poimongoid"];
                        NSArray *transferLines=[dicSubWays objectForKey:@"transferLine"];
                        
                        //  NSLog(@"@@@@@@@poimongoides===%@",poimongoides);
                        //  NSLog(@"@@@@@@@poimongoides===%@",[poimogoidesdsDic objectForKey:poimongoides]);
                        NSString *poiid=[poimogoidesdsDic objectForKey:poimongoides];
                        NSDictionary *poi=[poiDics objectForKey:poiid];
                        NSString *poiName=[poi objectForKey:@"name"];
                      //  NSLog(@"poi===%@",[poi objectForKey:@"name"]);//站点名称
                      
//                        if(firstStationLineId!=nil && [firstStationLineId isEqualToString: poiid]){//判断是否与起始站相连
//                            NSLog(@"!!!!firstStationLineId===%@",[poi objectForKey:@"name"]);//站点名称
//                        }
                        int lineoffx=offx+stationWidth/2;
                        int contentWidth=50;//连线的宽度高度
                        
                        int trsoffx=lineoffx-22;
                        int trsoffy=offy;
                        int max=4;
                        int indexcont=1;
                        for (id line in transferLines) {
                         //   NSLog(@"line===%@",line);
                            if(indexcont>max){
                                trsoffy-=16;
                                trsoffx=lineoffx-30;
                                indexcont=0;
                            }
                            NSDictionary *lineDic= [idSubDirs objectForKey: [NSString stringWithFormat:@"%@",line]];
                           // NSLog(@"linename===%@",[lineDic objectForKey:@"linename"]);
                            
                            UIImageView *view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[lineDic objectForKey:@"linename"]]]];
                            [view setFrame:CGRectMake(trsoffx, trsoffy+stationHeight-view.image.size.height/2, view.image.size.width, view.image.size.height)];
                            [self addSubview:view];
                            trsoffx-=view.image.size.width+3;
                            indexcont++;
                        }

                        

                        if(lastStationLineId!=nil && [lastStationLineId isEqualToString: poiid]){//判读是否与终点站相连
                         //   NSLog(@"!!!!lastStationLineIdlastStationLineId===%@",poiName);//站点名称
                            
                            [self drawLine:context point1:CGPointMake(lastStationPoint.x, lastStationPoint.y+16) point2:CGPointMake(lastStationPoint.x-60, lastStationPoint.y+contentWidth)];//线段
                            [self drawLine:context point1:CGPointMake(lastStationPoint.x-60, lastStationPoint.y+47) point2:CGPointMake(lastStationPoint.x-58, (offy+stationHeight-contentWidth))];//线段
                            [self drawLine:context point1:CGPointMake(lastStationPoint.x-60,offy+stationHeight-contentWidth-2) point2:CGPointMake(lastStationPoint.x, offy+stationHeight)];//线段
                            isLastStationToNest=true;
                        }
                        
                      // CGPoint stpoint= CGPointMake(lineoffx, offy);
                        NSMutableDictionary *dirCopy= [[NSMutableDictionary alloc]init];
                        
                        for(NSDictionary *dsw in dicSubWays){
                            [dirCopy setValue:[dicSubWays objectForKey:dsw] forKey:dsw];
                        }
                        
                        [dirCopy setValue:[NSNumber numberWithInt:lineoffx] forKey:@"x"];
                         [dirCopy setValue:[NSNumber numberWithInt:offy] forKey:@"y"];
                        [listSubWaysCopy addObject:dirCopy];
                      //  NSLog(@"=============%@",poiName);//站点名称
                             if(i==0){//画起始站
                                 firstStationLineId = poiid;
                                 isDrawFirst=true;
                                if(count>1){
                                     if(firstStationLineId!=nil && lastSecondLine!=nil){
                                         for(NSDictionary *dicSubWays in lastSecondLine){//倒数第2站所有站
                                             NSString *poimongoides=[dicSubWays objectForKey:@"poimongoid"];
                                             NSString *poiid=[poimogoidesdsDic objectForKey:poimongoides];
                                           //  NSDictionary *poi=[poiDics objectForKey:poiid];
                                             
                                             if([firstStationLineId isEqualToString: poiid]){//判断是否与起始站相连
                                               //  NSLog(@"!!!!poimongoides===%@",poimongoides);//站点名称
                                                 
                                               //  NSLog(@"!!!!firstStationLineId===%@",poiName);//站点名称
                                                 int x =[[dicSubWays objectForKey:@"x"] integerValue];
                                                 int y =[[dicSubWays objectForKey:@"y"] integerValue];
                                               //  NSLog(@"!!!!x===%d",x);
                                               //  NSLog(@"!!!!y===%d",y);
                                                 y+=stationHeight;
                                                 
                                                 [self drawLine:context point1:CGPointMake(x, y) point2:CGPointMake(x-60, y+contentWidth)];//线段
                                                 [self drawLine:context point1:CGPointMake(x-60, y+47) point2:CGPointMake(x-58, (offy+stationHeight-contentWidth))];//线段
                                                 [self drawLine:context point1:CGPointMake(x-60,offy+stationHeight-contentWidth-2) point2:CGPointMake(x, offy+stationHeight)];//线段
                                                 isDrawFirst =false;
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 if(isDrawFirst){
                                     [self drawRectangle:context point1:CGPointMake(offx, offy) point2:CGPointMake(offx+stationWidth,offy+8)];
                                     [self addSubview:[self getUILabel:poiName offx:offx+40 offy:offy-10 font:[UIFont fontWithName:@"Helvetica" size:15] poiid:poiid]];
                                    // NSLog(@"********%@",poiName);//站点名称
                                     //isDrawFirst=false;
                                 }else{
                                     offy=(offy+stationHeight);
                                 }
                             }else if(i!=count-1){//如果起始站也不是最后一站
                                 
                                 double offw= 0.2;
                                 double offh= 0.1;
                                 int x = offx+stationWidth/2;
                                 if(!isDrawFirst&& i==1){//如果起始站没绘制 
                                     [self drawLine:context point1:CGPointMake(lineoffx, offy) point2:CGPointMake(lineoffx, offy+stationHeight)];//线段
                                 }else{
                                  [self drawLine:context point1:CGPointMake(lineoffx, offy) point2:CGPointMake(lineoffx, offy=(offy+stationHeight))];//线段
                                 }
                                 [self drawTrigon:context point1:CGPointMake(x, offy) point2:CGPointMake(x+offw,offy+offh/2) point3:CGPointMake(x,offy+offh)];//三角形
                                 [self addSubview:[self getUILabel:poiName offx:offx+40 offy:offy-10 font:[UIFont fontWithName:@"Helvetica" size:15] poiid:poiid]];
                                 
                             }else{//最后一站
//                                NSLog(@"=============%@",poiName);//站点名称
                                 
                                 //lastSecondLine setValue:CGPointMake(lineoffx, offy) forKey:@"point"];
//                                 [self drawCurve:context point1:CGPointMake(lineoffx, offy) point2:CGPointMake(lineoffx, offy=(offy+20))];
//                                  NSLog(@"========pczzzzz=====%d",linei);//站点名称 
                                 if(linei ==lineicount-1){  //(明日继续)
                                     int lasty= offy;
                                     [self drawLine:context point1:CGPointMake(lineoffx, lasty) point2:CGPointMake(lineoffx, lasty=(lasty+stationHeight))];//线段
                                     
                                     [self drawRectangle:context point1:CGPointMake(offx, lasty) point2:CGPointMake(offx+stationWidth,lasty+8)];
                                     [self addSubview:[self getUILabel:[poi objectForKey:@"name"] offx:offx+40 offy:lasty-10 font:[UIFont fontWithName:@"Helvetica" size:15]poiid:poiid]];
                                 }
                                 
                                 if(!isLastStationToNest&&linei!=0){
                                     int lasty= lastStationPoint.y;
                                     [self drawLine:context point1:CGPointMake(lineoffx, lasty) point2:CGPointMake(lineoffx, lasty=(lasty+stationHeight))];//线段
                                     
                                     [self drawRectangle:context point1:CGPointMake(offx, lasty) point2:CGPointMake(offx+stationWidth,lasty+8)];
                                     [self addSubview:[self getUILabel:lastStationName offx:offx+40 offy:lasty-10 font:[UIFont fontWithName:@"Helvetica" size:15]poiid:poiid]];
                                 }
                                 
                                 lastStationPoint = CGPointMake(lineoffx, offy);
                                 [self drawLine:context point1:CGPointMake(lineoffx, offy) point2:CGPointMake(lineoffx, offy=(offy+20))];
                                 
                                 offy=(offy+stationHeight+50);
                                 lastStationLineId = poiid;//id
                                 lastStationName = [poi objectForKey:@"name"] ;
                                 lastSecondLine =[listSubWaysCopy copy];

                             }
                        i++;
                    }
                }
            linei++;
            }
        }
    }

    [scrollView setContentSize:CGSizeMake(320, offy)];

}

- (void)drawRectangle:(CGContextRef)_context point1:(CGPoint) _beginPoint point2:(CGPoint)_endPoint
{
    CGRect rect = CGRectMake(_beginPoint.x, _beginPoint.y, _endPoint.x - _beginPoint.x, _endPoint.y - _beginPoint.y);
    //设置矩形填充颜色：红色
   // CGContextSetRGBFillColor(_context, 1.0, 0.0, 0.0, 1.0);
    //填充矩形
    CGContextFillRect(_context, rect);
    //执行绘画
    CGContextStrokePath(_context);
}

//- (void)drawCurve:(CGContextRef)_context  point1:(CGPoint) _beginPoint point2:(CGPoint)_endPoint
//{
//    CGContextRef context = (CGContextRef)UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor (context, 0.863, 0.863, 0.863, 1);
//    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
//    double MSG_TRIANGLE_LINE_LENGTH =100;
//    float roundRectY = MSG_TRIANGLE_LINE_LENGTH * 0.71 + _beginPoint.y;
//    [trianglePath moveToPoint:CGPointMake(_beginPoint.x + 80, _beginPoint.y)];
//    [trianglePath addLineToPoint:CGPointMake(_beginPoint.x + 80 - MSG_TRIANGLE_LINE_LENGTH / 2, roundRectY + 3)];
//    [trianglePath addLineToPoint:CGPointMake(_beginPoint.x + 80 + MSG_TRIANGLE_LINE_LENGTH / 2, roundRectY + 3)];
//    [trianglePath addLineToPoint:CGPointMake(_beginPoint.x + 80, _beginPoint.y)];
//    UIBezierPath* roundRectPath = [UIBezierPath bezierPathWithRoundedRect:
//                                   CGRectMake(_beginPoint.x, roundRectY,
//                                              20, 20 - MSG_TRIANGLE_LINE_LENGTH * 0.71)
//                                                             cornerRadius:10];
//    [trianglePath closePath];
//    [roundRectPath closePath];
//    [trianglePath fill];
//    [roundRectPath fill];
//    
////    CGContextSetLineWidth(_context, 5);
////    CGContextSetRGBFillColor(_context, 0, 0, 0, 1);
////    CGContextMoveToPoint(_context, _beginPoint.x-20, _beginPoint.y+10); //移动到弧线的终点
////    CGContextAddArc(_context, _beginPoint.x-20, _beginPoint.y+10, 10.0f, 0, 3.1415926/2, 0); //50,50弧是中心，20是半径，0是起点角度，终点角度pi/2
////    CGContextStrokePath(_context);
//}


- (void)drawLine:(CGContextRef)_context point1:(CGPoint) _beginPoint point2:(CGPoint)_endPoint
{
    //设置矩形填充颜色：红色
    //CGContextSetRGBFillColor(_context, 1.0, 0.0, 0.0, 1.0);
//    CGContextSetRGBStrokeColor(_context, 1, 0, 0, 1);
    
    CGContextMoveToPoint(_context, _beginPoint.x, _beginPoint.y);
    CGContextAddLineToPoint(_context, _endPoint.x, _endPoint.y);
    CGContextSetLineWidth(_context, 8);
   
    CGContextStrokePath(_context);
}

- (void)drawTrigon:(CGContextRef)_context point1:(CGPoint) _beginPoint point2:(CGPoint)_midPoint point3:(CGPoint)_endPoint
{
    //设置矩形填充颜色：红色
    //CGContextSetRGBFillColor(_context, 1.0, 0.0, 0.0, 1.0);
//    CGContextSetRGBStrokeColor(_context, 1, 0, 0, 1);
    
    CGContextMoveToPoint(_context, _beginPoint.x, _beginPoint.y);
    CGContextAddLineToPoint(_context, _midPoint.x, _midPoint.y);
    CGContextAddLineToPoint(_context, _endPoint.x, _endPoint.y);
    CGContextSetLineWidth(_context, 8);
    CGContextClosePath(_context);
    CGContextStrokePath(_context);
}

-(StationUILabel *)getUILabel:(NSString *)text offx:(CGFloat) offx offy:(CGFloat) offyi font:(UIFont *)font poiid:(NSString *)poiid{
    //初始化label
    StationUILabel *label = [[StationUILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //设置自动行数与字符换行
    [label setNumberOfLines:0];
    label.lineBreakMode = UILineBreakModeWordWrap;
    // UIFont *font = [UIFont fontWithName:@"Verdana" size:14];
    UIColor *textColor=[[UIColor alloc]initWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f];
    //设置一个行高上限
    CGSize size = CGSizeMake(300,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(offx, offyi, labelsize.width, labelsize.height)];
    label.text=text;
    label.font = font;
    [label setTextColor:textColor];
    label.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subStationClick:)];
  //  gestureRecognizer.delegate = self;
    
    [label setUserInteractionEnabled:YES];     //设置label可进行触发  
    [label addGestureRecognizer:gestureRecognizer];
    [label setPoimongoid:poiid];
    return label;
}
-(void)subStationClick:(UITapGestureRecognizer *)sender{
    StationUILabel *label =[sender view];
    UIStoryboard *sb = [ViewController getStoryboard];
    SubWayStationViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;;
    [rb setPoimongoid:[label poimongoid]];
    
 //   NSLog(@"[label poimongoid]==%@",[label poimongoid]);
    
    [[self subWayDrawViewController].navigationController pushViewController:rb animated:YES];
    [[self subWayDrawViewController] presentModalViewController:rb animated:YES];
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//     return YES;
//}
@end
