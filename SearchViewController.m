//
//  SearchViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-30.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "SearchViewController.h"
#import "SubWayStationViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchbar;
@synthesize entries;
@synthesize filterEntries;
@synthesize tableView;
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
    [self registerForKeyboardNotifications];
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    
    //平铺
    tableView.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    tableView.rowHeight = kCustomRowHeight;
    
    if(entries==nil){
        entries =[[NSMutableArray alloc] init];
    }
    if(filterEntries==nil){
        filterEntries =[[NSMutableArray alloc] init];
    }
    [[searchbar.subviews objectAtIndex:0]removeFromSuperview];
    
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, searchbar.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"navetionbag"];
    [imageView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
    pcr=[[PCRectButton alloc] initWithFrame:CGRectMake(260, (imageView.frame.size.height-36), 56, 36) text:@"关闭"];
    
    
    [pcr.button addTarget:self action:@selector(guanbiClick) forControlEvents:UIControlEventTouchUpInside];
    [pcr setHidden:YES];
    
    [searchbar setFrame:CGRectMake(10, 0, 300, 46)];

    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:searchbar];
    [self.view addSubview:pcr];
    [self layoutSubviews];
    [self performSelectorInBackground:@selector(myThreadMainMethod:) withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)guanbiClick{
    [self doSearch:searchbar];
   [self hideKeyboard];
}
- (void) hideKeyboard {
    [searchbar setFrame:CGRectMake(10, 0, 300, 46)];
    [searchbar resignFirstResponder];
}

- (void)viewDidUnload
{
    tableView=nil;
    entries=nil;
    filterEntries=nil;
    [self setSearchbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)myThreadMainMethod:(id)sender
{
    NSString *sql =@"SELECT name,poimongoid,category FROM poi";// WHERE category='attraction'
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//    CLLocationCoordinate2D coord;
//    [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:entries setAllData:nil];
    
//    [resultSet close];
//    [db close];
    
    [self getData:sql data:entries];
    [self.tableView reloadData];
}
-(void)getData:(NSString*)sql data:(NSMutableArray *)setData{
    [ViewController getPoiBaseData:sql data:setData];
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//    while ([resultSet next]) {
//        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
//        NSString *name = [resultSet stringForColumn:@"name"];
//        NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
//        NSString *category = [resultSet stringForColumn:@"category"];
//
//        [resultDirs setObject:category forKey:@"category"];
//        [resultDirs setObject:name forKey:@"name"];
//        [resultDirs setObject:poimongoid forKey:@"poimongoid"];
//        [setData addObject:resultDirs];
//    }
//    
//    [resultSet close];
//    [db close];
    
}


- (void)layoutSubviews {
	UITextField *searchField;
	NSUInteger numViews = [searchbar.subviews count];
	for(int i = 0; i < numViews; i++) {
		if([[searchbar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
			searchField = [searchbar.subviews objectAtIndex:i];
		}
	}
	if(!(searchField == nil)) {
		//searchField.textColor = [UIColor redColor];
        //	[searchField setBackground: [UIImage imageNamed:@"search"] ];
		[searchField setBorderStyle:UITextBorderStyleRoundedRect];
       // searchField.layer.cornerRadius = 2.0;
        //searchField.leftViewMode = UITextFieldViewModeAlways;
       // [searchField.leftView setFrame:CGRectMake(-10, searchField.leftView.frame.origin.y, searchField.leftView.frame.size.width, searchField.leftView.frame.size.height)];
        searchField.returnKeyType =UIReturnKeyDone;
    
        [searchField leftViewRectForBounds:CGRectMake(searchField.leftView.frame.origin.x-10, searchField.leftView.frame.origin.y, searchField.leftView.frame.size.width, searchField.leftView.frame.size.height)];
        //leftViewRectForBounds
		UIImage *image = [UIImage imageNamed: @"searchleft"];
		UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, searchField.leftView.frame.size.width, searchField.leftView.frame.size.height)];
        [leftView addSubview:iView];
        [iView setFrame:CGRectMake(-5, 0,searchField.leftView.frame.size.width, searchField.leftView.frame.size.height)];
//        [searchbar setFrame:CGRectMake(10, 0, 240, 46)];
//        [pcr setHidden:NO];
		searchField.leftView = leftView;
	}
    
	[searchbar layoutSubviews];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    [self doSearch:searchBar];
}

/*搜索按钮*/
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[self doSearch:searchBar];
}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	[self doSearch:searchBar];
}

/*搜索*/
- (void)doSearch:(UISearchBar *)searchBar{
    NSString *text = searchBar.text;
    if(text==nil || [text length]==0){
        return;
    }else{
       
    }
    if(entries==nil){
         [self performSelectorInBackground:@selector(myThreadMainMethod:) withObject:nil];
    }
	
    [filterEntries removeAllObjects];
    NSArray *tempResult = [NSArray arrayWithArray:entries];
    for (NSMutableDictionary *mds in tempResult) {
        int rang =[[mds objectForKey:@"name"] rangeOfString:text].length ;
        if(rang>0){
            [filterEntries addObject:mds];
           // NSLog([mds objectForKey:@"name"]);
        }
    }
    [tableView reloadData];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown{
    [searchbar setFrame:CGRectMake(10, 0, 240, 46)];
    [pcr setHidden:NO];
}
-(void)keyboardWillBeHidden{
   [searchbar setFrame:CGRectMake(10, 0, 300, 46)];
    [pcr setHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filterEntries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard *sb = [ViewController getStoryboard];
//    DescriptionViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
//    rb.backIdentifier=@"SearchViewController";
//    [rb setPoiData:[self.filterEntries objectAtIndex:indexPath.row]];
//    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
//    [self.navigationController pushViewController:rb animated:YES];
//    [self presentModalViewController:rb animated:YES];
//    
//    
    NSMutableDictionary *poiData =[self.filterEntries objectAtIndex:indexPath.row];
    NSString *category = [poiData objectForKey:@"category"];
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb;
    NSString *poimongoid = [poiData objectForKey:@"poimongoid"];
    if([category isEqualToString:@"subway"]){//如果是地铁
        rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
        [((SubWayStationViewController *)rb) setPoimongoid:poimongoid];
        //[((SubWayStationViewController *)rb) setPoiData:poiData];
       // [((SubWayStationViewController *)rb) setIdSubDirs:nil];
    }else{
        rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
        ((DescriptionViewController *)rb).backIdentifier=@"SearchViewController";
        [((DescriptionViewController *)rb) setPoimongoid:poimongoid];
       // [((DescriptionViewController *)rb) setPoiData:poiData];
    }
    
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   // UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
   // {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        // cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
  //      cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kCustomRowHeight)];
  //  }
    UIView* bgView = [[UIView alloc] init] ;
    bgView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    [cell setSelectedBackgroundView:bgView];
    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
    
    
    NSMutableDictionary *poiData =[self.filterEntries objectAtIndex:indexPath.row];
    cell.textLabel.text =[poiData objectForKey:@"name"];
      [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    
    UIImage * jdtemp;
    NSData *data = [poiData objectForKey:@"image"];
    
    if(data==nil||data.length==0){
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
    
    return cell;
}



@end
