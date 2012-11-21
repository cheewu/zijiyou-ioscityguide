//
//  CityIntViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-24.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "CityIntViewController.h"

@interface CityIntViewController ()

@end

@implementation CityIntViewController
@synthesize objValue;
@synthesize entries;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
}
- (void)viewDidLoad
{
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    objValue = [[NSMutableArray alloc]init];
    entries= [[NSMutableArray alloc]init];
    NSArray *timages=[[NSArray alloc]initWithObjects:@"jianjie",@"jiaotong",@"meishi",@"dili",@"qihou",nil];
    
    NSString *sql =@"SELECT * FROM citydescription order by dindex";// integer primary key,dproperty varchar(10), dvalue text)
    FMDatabase *db= [ViewController getDataBase];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
    
    while ([resultSet next]) {
        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        NSString *dproperty = [resultSet stringForColumn:@"dproperty"];
        NSString *dvalue = [resultSet stringForColumn:@"dvalue"];
        [resultDirs setValue:dproperty forKey:@"dproperty"];
        [resultDirs setValue:dvalue forKey:@"dvalue"];
        [objValue addObject:dproperty];
        [entries addObject:resultDirs];
    }
    
    [resultSet close];
    [db close];
     typeImages = [[NSMutableDictionary alloc] initWithObjects:timages forKeys:objValue ];
    NSString *city_wiki=NSLocalizedStringFromTable(@"city_wiki", @"InfoPlist",nil);
     PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:city_wiki backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];
  
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}
-(void)clickBack:(id)sender{
    UIStoryboard *sb = [ViewController getStoryboard];
    RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return objValue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        // cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 80)];
    }
    
    cell.textLabel.text =[[self.entries objectAtIndex:indexPath.row] objectForKey:@"dproperty"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
  //    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    

    cell.imageView.image = [UIImage imageNamed:[typeImages objectForKey:cell.textLabel.text]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [ViewController getStoryboard];
    DetailGonglueViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Gonglue"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    
   //NSString *te= [[NSString alloc] initWithFormat:@"  %@",@""];
    
    rb.text =[[NSString alloc] initWithFormat:@"        %@",[[self.entries objectAtIndex:indexPath.row] objectForKey:@"dvalue"]];
    rb.title=  [[self.entries objectAtIndex:indexPath.row] objectForKey:@"dproperty"];
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    
}

- (void)viewDidUnload
{
    typeImages=nil;
    [self setEntries:nil];
    [self setObjValue:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
