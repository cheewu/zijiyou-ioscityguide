//
//  MoreViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-9.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "MoreViewController.h"
#import "PWebViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize pctop;
@synthesize mtabelView;

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
    NSString *poi_article=NSLocalizedStringFromTable(@"poi_article", @"InfoPlist",nil);
    objValue = [NSArray arrayWithObjects:@"意见反馈",@"推荐给朋友",@"关于",@"",@"", nil];
   // pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"更多" isShowBack:YES isShowRight:NO ];
    
    pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"更多" backTitle:nil righTitle:nil];
    
    [self.view addSubview: pctop];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
   [mtabelView setBackgroundColor:[UIColor clearColor]];
    mtabelView.rowHeight = kCustomRowHeight;
   // [mtabelView setBackgroundColor:[UIColor clearColor]];
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


- (void)viewDidUnload
{
    objValue=nil;
    pctop=nil;
    [self setMtabelView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        // cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kCustomRowHeight)];
        
//        UIButton *temp=[UIButton buttonWithType:UIButtonTypeCustom];
//        [temp setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 60, cell.frame.size.height)];
//        [temp setShowsTouchWhenHighlighted:YES];
//        [cell addSubview:temp];
    }
  //  if(indexPath.row!=0){
        UIImageView *tempIV=[[UIImageView alloc]init];
        [tempIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabelbag"]]];
        cell.backgroundView = tempIV;
//    }else{
//        //cell separatorColor为clear，然后把图片做的分割线添加到自定义的custom cell上。
//        UIImageView *tempseparator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"separator"]];
//       
//        [tempseparator setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y+cell.frame.size.height-2, tempseparator.frame.size.width, tempseparator.frame.size.height-5)];
//        
//        [cell addSubview:tempseparator];
//    }
//    
    
    cell.textLabel.text =[objValue objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"Heiti Tc-BOLD" size:22]];
     NSLog(@"cell.textLabel.frame.size.width=%f",cell.textLabel.frame.size.width);
  //  UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //[cell setBackgroundColor:[UIColor colorWithPatternImage:tabelbg]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    if(![cell.textLabel.text isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   

   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row==0){
//        //YouJi
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.zijiyou.com/article/4e8c091fd0c2ff482300031d"]];
//        UIStoryboard *sb = [ViewController getStoryboard];
//        PWebViewController *rb = [sb instantiateViewControllerWithIdentifier:@"YouJi"];
//        rb.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
//        [self.navigationController pushViewController:rb animated:YES];
//        [self presentModalViewController:rb animated:YES];
//        
    //}else
if(indexPath.row==0){
        [self sendMailInApp:@"我的意见" toMail:@"feedback@zijiyou.com" ];
    }else if(indexPath.row==1){
        [self sendMailInApp:@"推荐自己游" toMail:@""];
    }
}

#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)sendMailInApp:(NSString *)title toMail:(NSString *)to
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能!"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"您首先需要设置一下邮件账户"];
        return;
    }
    [self displayMailPicker:title toMail:to];

}

//调出邮件发送窗口
- (void)displayMailPicker:(NSString *)title toMail:(NSString *)to
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: title];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:to];
    [mailPicker setToRecipients: toRecipients];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailPicker setCcRecipients:ccRecipients];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    UIImage *addPic = [UIImage imageNamed: @"icon"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
//    //添加一个pdf附件
//    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
//    
    NSString *emailBody = @"<font color='red'>正文</font> ";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController: mailPicker animated:YES];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
     [self dismissModalViewControllerAnimated:YES];
  //   MoreViewController *mrb =(MoreViewController *)[self presentingViewController];
    RXCustomTabBar *rb =(RXCustomTabBar *)[controller presentingViewController];
    
   // NSLog(@"sadfasdfsadfasfdsaf=%@",[[controller presentingViewController] debugDescription]);
    [rb setSelectedIndex:4];
    [rb.btn1 setSelected:NO];
    [rb.btn5 setSelected:YES];
    //关闭邮件发送窗口
   
    

    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件已放到队列中";
           // [self alertWithMessage:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"保存或者发送邮件失败";
            [self alertWithMessage:msg];
            break;
        default:
            msg = @"";
            break;
    }
    
}

- (void)alertWithMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
}



@end
