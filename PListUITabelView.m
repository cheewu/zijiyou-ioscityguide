//
//  PListUITabelView.m
//  zijiyoun
//
//  Created by piaochunzhi on 12-9-19.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PListUITabelView.h"
#import "WBSendView.h"
@implementation PListUITabelView
@synthesize entries;
//@synthesize weiBoEngine;
@synthesize myAccountViewController;
@synthesize ptype;
@synthesize checkinEntries;
- (id)initWithFrame:(CGRect)frame entries:(NSMutableArray*) entrie
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setEntries:entrie];
        [self setDataSource:self];
        [self setDelegate:self];
        UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
        //平铺
        [self setBackgroundColor:[UIColor colorWithPatternImage:tabelbg]];
        [self setRowHeight:kCustomRowHeight];
    }
    [self reloadData];
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        // cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kAppRowHeight)];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *_poiData = [self.entries objectAtIndex:indexPath.row];
    NSString *poiid=[_poiData objectForKey:@"poiid"];
    NSDictionary *fac =[checkinEntries objectForKey:poiid];

    
    
    cell.textLabel.text =[_poiData objectForKey:@"name"];
    
    if(ptype==CheckInType){
        NSString *time=[fac objectForKey:@"time"];
        
        NSLog(@"time=======%@",time);
        
        NSDate *date;
//        if(time!=nil){
//            date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
//        }else{
            date = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
        //}
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YY年MM月dd日 HH:mm"];
        NSString *dateTime = [formatter stringFromDate:date];
        synButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *weiboImage=[UIImage imageNamed:@"synweibo"];
        [synButton setBackgroundImage:weiboImage forState:UIControlStateNormal];
        [synButton setFrame:CGRectMake(0, 0, weiboImage.size.width, weiboImage.size.height)];
      //  [synButton setImage:[UIImage imageNamed:@"synweibo"] forState:UIControlStateNormal];
        [synButton setTag:indexPath.row];
        [synButton setShowsTouchWhenHighlighted:YES];
        [synButton addTarget:self action:@selector(weiboSend:) forControlEvents:UIControlEventTouchUpInside];
//        if ([myAccountViewController.weiBoEngine isLoggedIn] && ![myAccountViewController.weiBoEngine isAuthorizeExpired])
//        {
//            [synButton setEnabled:YES];
//            [synButton setAlpha:1];
//        }else{
//            [synButton setEnabled:NO];
//            [synButton setAlpha:0.2];
//        }
        cell.accessoryView = synButton;
        
        cell.detailTextLabel.text=dateTime;//[[self.entries objectAtIndex:indexPath.row] objectForKey:@"address"];
        
       
    }else{
        NSString *address=[_poiData objectForKey:@"address"];
         cell.detailTextLabel.text=address;
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
   
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
     [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    // Configure the cell...
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
               NSDictionary *ent=[self.entries objectAtIndex:indexPath.row];
        NSString *ids;
               NSString *tableName;
        if(ptype==FavouriteType){
            tableName=@"favourite";
            ids = [ent objectForKey:@"favid"];
            //favid
        }else{
            tableName=@"checkin";
             ids = [ent objectForKey:@"id"];
        }
        
        FMDatabase *db=[ViewController getUserDataBase];
        NSString *sql=[[NSString alloc] initWithFormat:@"delete from %@ WHERE id='%@'",tableName,ids];
         NSLog(sql);
        if ([db open]) {
            [db executeUpdate:sql];
        }
        [entries removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData]; 
    }
}

-(void)weiboSend:(UIButton *)button{
    
    if ([myAccountViewController.weiBoEngine isLoggedIn] && ![myAccountViewController.weiBoEngine isAuthorizeExpired])
    {
        poiData = [self.entries objectAtIndex:[button tag]];
        NSString *poiid=[poiData objectForKey:@"poiid"];
        NSDictionary *fac =[checkinEntries objectForKey:poiid];
        
        NSString *description = [fac objectForKey:@"description"];
        NSData *imagename = [fac objectForKey:@"imagename"];

        
        NSMutableString *title=[[NSMutableString alloc] initWithFormat:@"#%@#  %@  %@",[poiData objectForKey:@"name"],description,@"  [来自@自己游旅游网]"];
        
               
        sendView = [[WBSendView alloc] initWithAppKey:[[self myAccountViewController].weiBoEngine appKey] appSecret:[[self myAccountViewController].weiBoEngine appSecret]  text:title image:[[UIImage alloc] initWithData:imagename]];
        
        [sendView setDelegate:self];
        
        [sendView show:YES];
        NSLog(@"weiboSend===%@",[poiData objectForKey:@"imagename"]);
        [[sendView sendButton] addTarget:self action:@selector(hiddenSendView) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [synButton setEnabled:NO];
        [[self myAccountViewController] checkLogIn];
        [self performSelector:@selector(buttonEnabled) withObject:nil afterDelay:1.0];
    }
}
-(void)hiddenSendView{
     [sendView hide:YES];;
}


-(void) buttonEnabled{
    [synButton setEnabled:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ptype==FavouriteType){
        UIStoryboard *sb = [ViewController getStoryboard];
        DescriptionViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
        rb.backIdentifier=@"MyAccountViewController";
        [rb setPoiData:[self.entries objectAtIndex:indexPath.row]];
        rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        [myAccountViewController.navigationController pushViewController:rb animated:YES];
        [myAccountViewController presentModalViewController:rb animated:YES];
    }
}



#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"微博发送成功！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"微博发送失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
}
@end
