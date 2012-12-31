//
//  MyAccountViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-24.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PListUITabelView.h"
#import "Reachability.h"
#import "ViewController.h"
@interface MyAccountViewController()

@end

@implementation MyAccountViewController
@synthesize userImage;
@synthesize userName;
@synthesize weiBoEngine;
@synthesize poiData;
@synthesize weiboView;

-(void)clickBack:(id)sender{
    UIStoryboard *sb = [ViewController getStoryboard];
    RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    
}
- (void)viewDidLoad
{
    [ViewController initializeDB];
     //[self performSelectorInBackground:@selector(setDB) withObject:nil];//移动数据库文件
  //  PCTOPUIview * pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"我的账户" isShowBack:YES isShowRight:YES];
    //NSString *city_name=NSLocalizedStringFromTable(@"city_name", @"InfoPlist",nil);
    NSString *my_wiki=NSLocalizedStringFromTable(@"my_wiki", @"InfoPlist",nil);
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:my_wiki backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];

    [pctop.rightButton addTarget:self action:@selector(clickWeiBoOut) forControlEvents:UIControlEventTouchUpInside];

    //HomeIndex
    [self.view addSubview: pctop];

    userImage.layer.borderWidth  = 2;
    userImage.layer.borderColor= [[UIColor whiteColor] CGColor];
    
    userImage.layer.shadowColor = [UIColor blackColor].CGColor;
    userImage.layer.shadowOffset = CGSizeMake(4, 4);
    userImage.layer.shadowOpacity = 0.5;
    userImage.layer.shadowRadius = 3.0;

    UIView *butBagUIView=[[UIView alloc]initWithFrame:CGRectMake(-1, 182, 322, 45)];
    
    [butBagUIView setBackgroundColor:[[UIColor alloc]initWithRed:254/255.0f green:254/255.0f blue:239/255.0f alpha:1.0f]];
    butBagUIView.layer.borderWidth  = 1;
    butBagUIView.layer.borderColor=[[[UIColor alloc]initWithRed:225/255.0f green:225/255.0f blue:220/255.0f alpha:1.0f] CGColor];
    
    UIImageView *su =[[UIImageView alloc]initWithFrame:CGRectMake(162, 10,1, 25)];
    [su setImage:[UIImage imageNamed:@"sline"]];
    
//    UIView *leftUIView=[[UIView alloc]initWithFrame:CGRectMake(30, 189, 100, 31)];
//    leftUIView.layer.borderWidth  = 1;
//    leftUIView.layer.borderColor= [[[UIColor alloc]initWithRed:201/255.0f green:201/255.0f blue:175/255.0f alpha:1.0f] CGColor];
//    leftUIView.layer.cornerRadius = 4.0;
//    leftUIView.layer.masksToBounds = YES;
//    [leftUIView setBackgroundColor:[[UIColor alloc]initWithRed:233/255.0f green:231/255.0f blue:202/255.0f alpha:1.0f]];
//    UIButton *button
    NSString *my_checkin=NSLocalizedStringFromTable(@"my_checkin", @"InfoPlist",nil);
     NSString *my_favourite=NSLocalizedStringFromTable(@"my_favourite", @"InfoPlist",nil);
    
    leftb=[[PCustAButtonView alloc]initWithFrame:CGRectMake(30, 7, 110, 31) imageName:@"checkin" text:my_checkin ];
    rightb=[[PCustAButtonView alloc]initWithFrame:CGRectMake(190, 7, 110, 31) imageName:@"favourite" text:my_favourite];
    
    [[leftb button] addTarget:self action:@selector(selectButtonCheckIn) forControlEvents:UIControlEventTouchUpInside];
     [[rightb button] addTarget:self action:@selector(selectButtonFav) forControlEvents:UIControlEventTouchUpInside];
    [butBagUIView addSubview: leftb];
    [butBagUIView addSubview: rightb];
    
    [rightb isSelect:NO];
    
    [butBagUIView addSubview: su];
    [self.view addSubview: butBagUIView];
    
    
   // SELECT * FROM checkin
    NSMutableDictionary *checkinEntries=[[NSMutableDictionary alloc]init];
    NSString *sqlcheckin =@"SELECT * FROM checkin order by time desc";// WHERE category='attraction'
    FMDatabase *db= [ViewController getUserDataBase];
    FMResultSet *resultCheckInSet  =[ViewController getDataBase:sqlcheckin db:db];//
    NSMutableString *poiids=[[NSMutableString alloc]init];

    while ([resultCheckInSet next]) {
        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        NSString *poiid = [resultCheckInSet stringForColumn:@"poiid"];
        NSString *time = [resultCheckInSet stringForColumn:@"time"];
        NSString *description = [resultCheckInSet stringForColumn:@"description"];
        NSData *imagename = [resultCheckInSet dataForColumn:@"imagename"];
        NSString *idSet = [resultCheckInSet stringForColumn:@"id"];
        [resultDirs setObject:idSet forKey:@"id"];
        [resultDirs setObject:poiid forKey:@"poiid"];
        [resultDirs setObject:time forKey:@"time"];
        [resultDirs setObject:description forKey:@"description"];
        if(imagename!=nil){
            [resultDirs setObject:imagename forKey:@"imagename"];
        }
        [checkinEntries setObject:resultDirs forKey:poiid];
       // [checkinEntries addObject:resultDirs];
        [poiids appendString:poiid];
        [poiids appendString:@","];
    }
    NSLog(@"poiids =====  %@",poiids);
    NSMutableArray* poiEntries=[[NSMutableArray alloc]init];
    NSString * ins;
    if([poiids length]>0){
        ins= [poiids substringToIndex:[poiids length]-1];
        NSLog(@"instring =====  %@",ins);
        [resultCheckInSet close];
        NSString *sql =[[NSString alloc]initWithFormat:@"SELECT * FROM poi WHERE poiid in (%@)", ins];
        FMDatabase *poidb= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:poidb];//
        CLLocationCoordinate2D coord;
        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:poiEntries setAllData:nil];
        [resultSet close];
        [poidb close];
    }
    NSMutableArray *ordpoiEntries=[[NSMutableArray alloc]init];
    for (NSMutableDictionary *pen in poiEntries) {//增加 favid 用来排序
        // NSLog(@"[pen objectForKey:poiid]=%@",[pen objectForKey:@"poiid"]);
        NSString *poiidc= [pen objectForKey:@"poiid"];
        NSMutableDictionary *pencopy =[pen mutableCopy];
        [pencopy setObject:[[checkinEntries objectForKey:poiidc] objectForKey:@"id"] forKey:@"id"];
        [ordpoiEntries addObject:pencopy];
        // [pen setObject:[favPoiEntries objectForKey:[pen objectForKey:@"poiid"]] forKey:@"favid"];
    }
    NSSortDescriptor *sortDescriptorChk = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptorsChk = [NSArray arrayWithObject:sortDescriptorChk];
    [ordpoiEntries sortUsingDescriptors:sortDescriptorsChk];
    
    
     
    NSMutableDictionary *favPoiEntries=[[NSMutableDictionary alloc]init];
    NSMutableArray *favouriteEntries=[[NSMutableArray alloc]init];
    NSString *sqlcfavourite =@"SELECT * FROM favourite order by id desc";// WHERE category='attraction'
    FMDatabase *favouritedb= [ViewController getUserDataBase];
    FMResultSet *resultsFavset  =[ViewController getDataBase:sqlcfavourite db:favouritedb];//
    NSMutableString *favsql=[[NSMutableString alloc]init];
    while ([resultsFavset next]) {
        NSString *poiid = [resultsFavset stringForColumn:@"poiid"];
        NSString *fid = [resultsFavset stringForColumn:@"id"];
        [favPoiEntries setObject:fid forKey:poiid];
        [favsql appendString:poiid];
        [favsql appendString:@","];
    }
    NSLog(@"poiids =====  %@",favsql);
   // NSMutableArray* poiFavEntries=[[NSMutableArray alloc]init];
    NSString * insFav;
    if([favsql length]>0){
        insFav= [favsql substringToIndex:[favsql length]-1];
        NSLog(@"insFav =====  %@",insFav);
        [resultCheckInSet close];
        NSString *sql =[[NSString alloc]initWithFormat:@"SELECT * FROM poi WHERE poiid in (%@)", insFav];
        FMDatabase *poidb= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:poidb];//
        CLLocationCoordinate2D coord;
        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:favouriteEntries setAllData:nil];
        [resultSet close];
        [poidb close];
    }
    NSMutableArray *filterfavouriteEntries=[[NSMutableArray alloc]init];
    for (NSMutableDictionary *pen in favouriteEntries) {//增加 favid 用来排序
       // NSLog(@"[pen objectForKey:poiid]=%@",[pen objectForKey:@"poiid"]);
        NSString *poiidc= [pen objectForKey:@"poiid"];
        NSMutableDictionary *pencopy =[pen mutableCopy];
        [pencopy setObject:[favPoiEntries objectForKey:poiidc] forKey:@"favid"];
        [filterfavouriteEntries addObject:pencopy];
       // [pen setObject:[favPoiEntries objectForKey:[pen objectForKey:@"poiid"]] forKey:@"favid"];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"favid" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [filterfavouriteEntries sortUsingDescriptors:sortDescriptors];

    
//    NSMutableArray *favouriteEntries=[[NSMutableArray alloc]init];
//    NSString *sqlcfavourite =@"select * from poi ,favourite  where poi.poiid in(favourite.poiid) order by favourite.id desc";
//    FMResultSet *resultsFavset  =[ViewController getDataBase:sqlcfavourite db:db];//
//    CLLocationCoordinate2D coord;
//    [ViewController setPoiArray:resultsFavset isNeedDist:NO coord:coord setEntries:favouriteEntries setAllData:nil];
//    [resultsFavset close];
//    [db close];

    listUIView=[[UIView alloc]initWithFrame:CGRectMake(0, 227, 320, 234)];
    PListUITabelView *checkinUIView=[[PListUITabelView alloc]initWithFrame:CGRectMake(0, 0, listUIView.frame.size.width, listUIView.frame.size.height) entries:ordpoiEntries];
    PListUITabelView *faUIView=[[PListUITabelView alloc]initWithFrame:CGRectMake(0, 0, listUIView.frame.size.width, listUIView.frame.size.height) entries:filterfavouriteEntries];
    
    checkinUIView.ptype = CheckInType;
    faUIView.ptype = FavouriteType;
    checkinUIView.myAccountViewController=self;
    [checkinUIView setCheckinEntries: checkinEntries];
    faUIView.myAccountViewController=self;
    
    [listUIView addSubview:faUIView];
    [listUIView addSubview: checkinUIView];

    [self.view addSubview: listUIView];

    [super viewDidLoad];
    
    weiboView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, 440,480)];
    [self.view addSubview: weiboView];
    [self.view bringSubviewToFront:weiboView];
    
	self.weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [weiBoEngine setRootViewController:self];
    [weiBoEngine setDelegate:self];
    [weiBoEngine setRedirectURI:@"http://"];
    [weiBoEngine setIsUserExclusive:NO];
    
    [super viewDidLoad];
    [self checkLogIn];
}

-(void)selectButtonCheckIn{
    [leftb isSelect:YES];
    [rightb isSelect:NO];
    
    for (id subview in listUIView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [PListUITabelView class]])
            if(((PListUITabelView *)subview).ptype == CheckInType)
            {
                [listUIView bringSubviewToFront:subview];
            }
    }
}

-(void)selectButtonFav{
    [rightb isSelect:YES];
    [leftb isSelect:NO];
    for (id subview in listUIView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [PListUITabelView class]])
            if(((PListUITabelView *)subview).ptype == FavouriteType)
            {
                [listUIView bringSubviewToFront:subview];
            }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)checkLogIn{
    if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        

        NSString *ids = weiBoEngine.userID;
        NSLog(@"ids=%@",ids);
        NSString *profile_image_url;
        NSString *sqls =[[NSString alloc]initWithFormat:@"select * from user where id='%@'",ids];
        
        NSLog(@"sqls=%@",sqls);
        FMDatabase *db= [ViewController getUserDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sqls db:db];
        while ([resultSet next]) {
            [[self userName]setText:[resultSet objectForColumnName:@"name"]];
            profile_image_url=[resultSet objectForColumnName:@"profile_image_url"];
        }
        NSLog(@"profile_image_url=%@",profile_image_url);
        if(profile_image_url==nil){//数据库里没有用户信息
            [self onLogOutOAuth];
            [self performSelector:@selector(onLogInOAuth) withObject:nil afterDelay:1.0];
        }else{
            NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/User/userimage.png"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:downloadPath];
                [userImage setImage:image];
            }else{
                [NSThread detachNewThreadSelector:@selector(imageResourceRequest:) toTarget:self withObject:profile_image_url];
            }
            [self.weiboView removeFromSuperview];
        }
        
    }else{
        [self performSelector:@selector(onLogInOAuth) withObject:nil afterDelay:1.0];
    }
}

- (void)onLogInOAuth
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    if([r currentReachabilityStatus]!=NotReachable){
        [weiBoEngine logIn];
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"没有网络！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
    
   //  [self performSelector:@selector(sss) withObject:nil afterDelay:1.0];
    

   //  [[[weiBoEngine authorize] rootViewController].view setHidden:YES];
}
-(void)HiddenWeibo{
    [weiBoEngine hidenWebView];
     weiBoEngine = nil;
}

- (void)onLogOutOAuth
{
    [weiBoEngine logOut];
    NSString *documentsDirectory= [NSHomeDirectory()
                                   stringByAppendingPathComponent:@"Library/User"];
    [self delUserInfoIfExit:[documentsDirectory stringByAppendingString:@"/userinfo.text"]];
    [self delUserInfoIfExit:[documentsDirectory stringByAppendingString:@"/userimage.png"]];
    UIImage *image = [UIImage imageNamed:@"myIcon"];
    [userImage setImage:image];
    [self.userName setText:@""];
}

-(void)clickWeiBoOut{
    [self onLogOutOAuth];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"注销成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
    [alertView show];
}


- (void)viewDidUnload
{
    rightb =nil;
    leftb=nil;

    [self setPoiData:nil];
    [self setUserName:nil];
    [self setUserImage:nil];
    [self setWeiBoEngine:nil];
}



#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        
    }
}

#pragma mark - WBLogInAlertViewDelegate Methods

- (void)logInAlertView:(WBLogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password
{
    [weiBoEngine logInUsingUserID:userID password:password];
    
    //    [indicatorView startAnimating];
}


#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请先登出！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    
   // NSLog(weiBoEngine.accessToken);
  //  NSLog(weiBoEngine.userID);
    
   // [weiBoEngine logInUsingUserID:weiBoEngine.userID password:nil];
    [params setObject:weiBoEngine.accessToken forKey:@"access_token"];
    [params setObject:weiBoEngine.userID forKey:@"uid"];
    [weiBoEngine loadRequestWithMethodName:@"users/show.json"
                                httpMethod:@"GET"
                                    params:params
                              postDataType:kWBRequestPostDataTypeNone
                          httpHeaderFields:nil];
    
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
//													   message:@"登录成功！"
//													  delegate:self
//											 cancelButtonTitle:@"确定"
//											 otherButtonTitles:nil];
//    [alertView setTag:kWBAlertViewLogInTag];
//	[alertView show];
}
- (void)request:(WBRequest *)request didReceiveRawData:(NSData *)data{
    NSLog(@"didReceiveRawData");
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [self.weiboView removeFromSuperview];
    for (id subview in listUIView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [PListUITabelView class]])
        {
            [((PListUITabelView *)subview) reloadData];
        }
    }
    //登录成功
    //    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSString *idstr,*screen_name,*profile_image_url;
        NSDictionary *dict = (NSDictionary *)result;
        NSArray *keys =[dict allKeys];
        for (NSString *key in keys) {
            //idstr //screen_name //profile_image_url //avatar_large
            NSLog(@"KEY=%@,%@value=",key,[dict objectForKey:key]);
        }
        idstr= [dict objectForKey:@"idstr"];
        screen_name= [dict objectForKey:@"screen_name"];
        profile_image_url= [dict objectForKey:@"avatar_large"];
        
        [self.userName setText:screen_name];
        
        
        //NSFileManager *fileManager=[NSFileManager defaultManager];
        NSString *documentsDirectory= [NSHomeDirectory()
                                       stringByAppendingPathComponent:@"Library/User/userinfo.text"];
        [self delUserInfoIfExit:documentsDirectory];
        
        
        [screen_name writeToFile:documentsDirectory atomically:YES
                encoding:NSUTF8StringEncoding error:nil];

      bool b= [ViewController addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:documentsDirectory]];
        
        
        [NSThread detachNewThreadSelector:@selector(imageResourceRequest:) toTarget:self withObject:profile_image_url];  
        
        FMDatabase *db= [ViewController getUserDataBase];
        if ([db open]) {
            NSString *sql = @"insert into user (id, name,profile_image_url) values (?, ?,?)";
            [db executeUpdate:sql, idstr, screen_name,profile_image_url];
            
            NSLog(@"idstr=%@;%@screen_name=;profile_image_url=%@",idstr,screen_name,profile_image_url);
            

            FMResultSet *resultSet  =[ViewController getDataBase:@"select * from user" db:db];
            while ([resultSet next]) {
                NSLog(@"resultSet=%@",[resultSet objectForColumnIndex:0]);

            }

        }else{
            NSLog(@"db not open");
        }
        [db close];
    }
}
static int retryCount=0;
//请求图片资源
-(void)imageResourceRequest:(NSString *)url
{
    @try { 
        //根据网络数据，获得到image资源
        NSData  *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        if(image == nil){
        }else {
            NSMutableDictionary *mutable = [[NSMutableDictionary alloc]init];
            [mutable setObject:url forKey:@"url"];
            [mutable setObject:image forKey:@"data"];
            //回到主线程，显示图片信息
            [self performSelectorOnMainThread:@selector(displayImage:) withObject:mutable waitUntilDone:NO];
        }
    }@catch (NSException *exception) {
        if(retryCount<1){//重试
            retryCount++;
            [self imageResourceRequest:url];
        }
        
    }
}

//显示图片信息
-(void)displayImage:(NSMutableDictionary *)imageDataDictionary
{
    UIImage* image = (UIImage *)[imageDataDictionary objectForKey:@"data"];
    //NSString* url = (NSString *)[imageDataDictionary objectForKey:@"url"];
    //[FlowerPicData instanceAddObject:url : image];
    //[_gridView reloadData];
    [userImage setImage:image];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory()
                                   stringByAppendingPathComponent:@"Library/User/userimage.png"];
    
    [self delUserInfoIfExit:documentsDirectory];
    
    NSData *binaryImageData = UIImagePNGRepresentation(image);
    NSURL * dburl = [NSURL fileURLWithPath:documentsDirectory];
    [fileManager createFileAtPath:documentsDirectory contents:binaryImageData attributes:nil];
    [ViewController addSkipBackupAttributeToItemAtURL:dburl];
    //NSData *data = [NSData dataWithContentsOfFile:documentsDirectory];
    
   // [userImage setImage:[UIImage imageWithData:data]];

}

-(void)delUserInfoIfExit:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory()
                                   stringByAppendingPathComponent:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        [fileManager removeItemAtPath:documentsDirectory error:nil];
    }
}


- (void)request:(WBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveRawData");
}


- (void)request:(WBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [self HiddenWeibo];
//    weiBoEngine = nil;
//    [weiBoEngine hidenWebView];
    //[[[weiBoEngine authorize] rootViewController].view setHidden:YES];
}

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"didFinishLoadingWithResult");
    
}



- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
    
    //[weiBoEngine hidenWebView];
}

//- (void)engineDidLogOut:(WBEngine *)engine
//{
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
//													   message:@"登出成功！"
//													  delegate:self
//											 cancelButtonTitle:@"确定"
//											 otherButtonTitles:nil];
//    [alertView setTag:kWBAlertViewLogOutTag];
//	[alertView show];
//}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"请重新登录！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}

@end
