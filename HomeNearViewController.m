//
//  HomeNearViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-28.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define kAppIconHeight    60
#define SEARCHRANG 2000  //查找 附近的距离
#import "HomeNearViewController.h"
#import "PCBackUIButton.h"
#import "PCTOPUIview.h"
#import "SubWayStationViewController.h"
#import "MyMapBoxView.h"
@interface HomeNearViewController ()

@end
@implementation HomeNearViewController
@synthesize locationManager;
@synthesize subView;
@synthesize firstView;
@synthesize tableView;
@synthesize entries;


- (void)viewDidLoad
{
     [ViewController showWaiting:self.view];
    // Return the number of sections.
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag.png"];
    
    //平铺
    tableView.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    tableView.rowHeight = kCustomRowHeight;
    //tableView.delegate=self;
    //tableView.dataSource=self;
    if(locationManager==nil){
        locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10.0f;
    }
    //启动位置更新
    [locationManager startUpdatingLocation];
    allData=[[NSMutableArray alloc] init];
    
    if(entries==nil){
        entries =[[NSMutableArray alloc] init];
    }else{
        [tableView reloadData];
    }
    NSString *button_select=NSLocalizedStringFromTable(@"button_select", @"InfoPlist",nil);
    
    pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"附近景点" backTitle:nil righTitle:button_select];
    [self.firstView addSubview: pctop];
    

    crm = [[CustomRightMenuView alloc]initWithFrame:CGRectMake(320, 0, 120, 480)];
    crm.delegate=self;
    crm.mainView=firstView;
    [crm setActionButton:pctop.rightButton];
    [subView addSubview:crm];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
   
}


- (void)viewDidUnload
{
    locationManager=nil;
    tableView=nil;
    entries=nil;
    
    [self setTableView:nil];
    [self setFirstView:nil];
    [self setSubView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
   [locationManager stopUpdatingLocation];
   locationManager=nil;
    NSString *errorType = (error.code == kCLErrorDenied) ? @"访问被拒绝,将无法找到您的位置！":@"获取位置信息失败！";

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"定位失败！"
                          message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}
CLLocationCoordinate2D center;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    [locationManager setDelegate:nil];
    locationManager=nil;
    
    center = newLocation.coordinate;
    
    RMSphericalTrapezium bounds = [MyMapBoxView getBounds:center distance:SEARCHRANG];
    

    NSMutableString *sql =[[NSMutableString alloc] initWithFormat:@"SELECT * FROM poi "];
    [sql appendFormat: @"WHERE latitude > %f  AND latitude < %f",bounds.southWest.latitude,bounds.northEast.latitude];
    [sql appendFormat:@" AND longitude > %f  AND longitude < %f",bounds.southWest.longitude,bounds.northEast.longitude];
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];
    //读取数据
//    [ViewController setPoiArray:resultSet isNeedDist:YES coord:newLocation.coordinate setEntries:entries setAllData:allData];
    [self getData:sql data:entries clocation:center];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
   // [allData sortUsingDescriptors:sortDescriptors];
    [entries sortUsingDescriptors:sortDescriptors];
    
//   // entries= [allData copy];
//      //  NSLog(@"%d",entries.count);
//    [resultSet close];
//    [db close];
    [ViewController hideWaiting:self.view];
    [tableView reloadData];
    if([entries count]==0){
        
    }
    for (NSMutableDictionary *rd in entries) {//延迟放入所有  方便筛选
        [allData addObject:[rd copy]];
    }
}

-(void)getData:(NSString*)sql data:(NSMutableArray *)setData clocation:(CLLocationCoordinate2D)clocation {
    FMDatabase *db= [ViewController getDataBase];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
    while ([resultSet next]) {
               // NSString *name = [resultSet stringForColumn:@"name"];
        NSString *name = [NSDataDES getContentByHexAndDes:[resultSet stringForColumn:@"name"] key:deskey] ;
        if(name==nil){//解密失败
            continue;
        }
        NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
        NSString *category = [resultSet stringForColumn:@"category"];
        NSData *img = [resultSet dataForColumn:@"image"];
        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        [resultDirs setObject:name forKey:@"name"];
        [resultDirs setObject:poimongoid forKey:@"poimongoid"];
        [resultDirs setObject:category forKey:@"category"];
        CLLocationCoordinate2D coord;
        coord.latitude =  [resultSet doubleForColumn:@"latitude"];
        coord.longitude =  [resultSet doubleForColumn:@"longitude"];

        if(img!=nil){
            [resultDirs setObject:img forKey:@"image"];
        }
        double distance = [MyMapBoxView getDistanceLatA:coord.latitude lngA:coord.longitude latB:clocation.latitude lngB:clocation.longitude];
        [resultDirs setObject:[[NSNumber alloc] initWithDouble:distance] forKey:@"distance"];
        
        [setData addObject:resultDirs];
    }
    [resultSet close];
    [db close];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       NSLog(@"[entries count]=%d",[entries count]);
    return [entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   // UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil)
   // {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        // cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
      //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kCustomRowHeight)];
    //}

    UIView* bgView = [[UIView alloc] init] ;
    bgView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    [cell setSelectedBackgroundView:bgView];
    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
    
    cell.textLabel.text =[[self.entries objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text=[[NSString alloc] initWithString:[NSString stringWithFormat:@"距离：%.0f米",[[[self.entries objectAtIndex:indexPath.row] objectForKey:@"distance"] doubleValue]]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
      [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
   // UIView *uibgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
   // UIImage * tabelbg= [UIImage imageNamed:@"tabelbag.png"];
    
    //UIImageView *uiv=[[UIImageView alloc] init];
    //平铺
   // uiv.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    
  //  [uiv setFrame:uibgView.frame];
   // [uibgView addSubview:uiv];

    
    UIImage * jdtemp;
    NSData *data = [[self.entries objectAtIndex:indexPath.row] objectForKey:@"image"];
    
    if(data==nil|| data.length==0){
        jdtemp= [UIImage imageNamed:@"TempImage"];
    }else{
        jdtemp=[UIImage imageWithData: data];
    }
    CGSize itemSize = CGSizeMake(kAppIconHeight+20, kAppIconHeight);
    UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [jdtemp drawInRect:imageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.imageView.image = newImage;
    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.imageView.layer.borderWidth  = 5;
    cell.imageView.layer.borderColor= [[UIColor whiteColor] CGColor];
    
    cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imageView.layer.shadowOffset = CGSizeMake(3, 3);
    cell.imageView.layer.shadowOpacity = 0.25;
    cell.imageView.layer.shadowRadius = 3.0;
    
  //  [cell setBackgroundView:uibgView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard *sb = [ViewController getStoryboard];
//    DescriptionViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
//   // rb.title = [[self.entries objectAtIndex:indexPath.row] objectForKey:@"name"];
//    rb.backIdentifier=@"HomeNearViewController";
//    
//    [rb setPoiData:[self.entries objectAtIndex:indexPath.row]];
//    
//    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
//    [self.navigationController pushViewController:rb animated:YES];
//    [self presentModalViewController:rb animated:YES];
//    
    NSMutableDictionary *poiData =[self.entries objectAtIndex:indexPath.row];
    NSString *category = [poiData objectForKey:@"category"];
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb;
    
//    if([category isEqualToString:@"subway"]){//如果是地铁
//        rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
//        [((SubWayStationViewController *)rb) setPoiData:poiData];
//        [((SubWayStationViewController *)rb) setIdSubDirs:nil];
//    }else{
//        rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
//        ((DescriptionViewController *)rb).backIdentifier=@"HomeNearViewController";
//        [((DescriptionViewController *)rb) setPoiData:poiData];
//    }
    if([category isEqualToString:@"subway"]){//如果是地铁
        rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
        [((SubWayStationViewController *)rb) setPoimongoid:[poiData objectForKey:@"poimongoid"]];
        [((SubWayStationViewController *)rb) setPoiData:nil];
        [((SubWayStationViewController *)rb) setIdSubDirs:nil];
    }else{
        rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
        ((DescriptionViewController *)rb).backIdentifier=@"HomeNearViewController";
        [((DescriptionViewController *)rb) setPoimongoid:[poiData objectForKey:@"poimongoid"]];
        [((DescriptionViewController *)rb) setPoiData:nil];
    }

    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];

    [self.tableView reloadData];
}

- (void)callbackClick:(id)sender{
    int indeBut =[sender tag];
    
    BOOL isHidden=![sender isSelected];//没被选中
    //   NSMutableDictionary *resultDirs=[entries objectAtIndex:indeBut-1];
     [entries removeAllObjects];
    if(indeBut==1){
        if(isHidden){
           
        }else{
            for (NSMutableDictionary *data in allData) {
              //   NSLog(@"distance===%f",[[data objectForKey:@"distance"] doubleValue]);
                 [entries addObject:[data copy]];
            }
        }
        [self.tableView reloadData];
        return;
    }
    
    NSMutableDictionary *buttons = [crm buttonDirects];
    
    for (NSDictionary *nmud in allData) {
      //  NSLog(@"distance===%f",[[nmud objectForKey:@"distance"] doubleValue]);

        
        NSString *category =[nmud objectForKey:@"category"];
            for (RightMenuButton *rightBut  in [buttons allValues]) {
                NSString * categoryNow=[rightBut categoryName];
                if([category isEqualToString:categoryNow]){
                    if(![[rightBut listSelectImage] isHidden]){
                        if([category isEqualToString:categoryNow]){
                            [entries addObject:[nmud copy]];
                        }
                    }
                }
            }
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
