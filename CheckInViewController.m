//
//  CheckInViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-16.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "CheckInViewController.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController
@synthesize labelText;
@synthesize contentTextFeil;
@synthesize paizhaoButton;
@synthesize xiangceButton;
@synthesize poiData;
@synthesize imageView;

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
    NSString *title=[poiData objectForKey:@"name"];
    poiid=[poiData objectForKey:@"poiid"];
    UIView *poiDetail=[[UIView alloc]init];
    
    
    UIImage *im=[UIImage imageNamed:@"checkin"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:im];
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18]];
    UIColor *backColor=[[UIColor alloc]initWithRed:247/255.0f green:246/255.0f blue:241/255.0f alpha:1.0f];
    UIColor *textColor=[[UIColor alloc]initWithRed:95/255.0f green:87/255.0f blue:73/255.0f alpha:1.0f];
    [label setTextColor:textColor];
    [self.view setBackgroundColor:backColor];
    [imageView setFrame:CGRectMake(10, 5, im.size.width-10, im.size.width-10)];
    
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [title sizeWithFont:label.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(40, 0, labelsize.width+15, 35)];
    [poiDetail setFrame:CGRectMake(15, 60, labelsize.width+im.size.width+15, 35)];
    
    [poiDetail addSubview:imageView];
    [poiDetail addSubview:label];
    [poiDetail setBackgroundColor:[UIColor whiteColor]];
    
    poiDetail.layer.borderWidth  = 1;
    poiDetail.layer.borderColor= [[[UIColor alloc]initWithRed:166/255.0f green:166/255.0f blue:166/255.0f alpha:255] CGColor];
    poiDetail.layer.shadowColor = [UIColor blackColor].CGColor;
    poiDetail.layer.shadowOffset = CGSizeMake(10,1);
    poiDetail.layer.shadowOpacity = 0.2;
    poiDetail.layer.shadowRadius = 3.0;
    poiDetail.layer.cornerRadius = 4.0;
    poiDetail.layer.masksToBounds = YES;
    [labelText setTextColor:label.textColor];
    [labelText setAlpha:0.5];
    NSString *poi_checkin=NSLocalizedStringFromTable(@"poi_checkin", @"InfoPlist",nil);
    NSString *checkin_send=NSLocalizedStringFromTable(@"checkin_send", @"InfoPlist",nil);
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:poi_checkin backTitle:@"" righTitle:checkin_send];
    
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    [pctop.rightButton addTarget:self action:@selector(clickCheckIn) forControlEvents:UIControlEventTouchUpInside];
    [paizhaoButton addTarget:self action:@selector(paizhaoClick) forControlEvents:UIControlEventTouchUpInside];
    [paizhaoButton setShowsTouchWhenHighlighted:YES];
    [xiangceButton addTarget:self action:@selector(xiangceClick) forControlEvents:UIControlEventTouchUpInside];
    
    //HomeIndex
    [self.view addSubview: pctop];

    [self.view addSubview: poiDetail];
    [super viewDidLoad];
    [contentTextFeil setDelegate:self];
    [contentTextFeil becomeFirstResponder];
	// Do any additional setup after loading the view.
}

-(void)paizhaoClick{
    [self showCamera];
}

-(void)xiangceClick{
    [self showAlbum];
}
- (void)showCamera
{
    @try {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
	if (imagePickerController == nil)
	{
        imagePickerController = [[UIImagePickerController alloc] init]; 
		imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
    }
    [self presentModalViewController:imagePickerController animated:YES];
    }@catch (NSException* e) {
          [self showAlbum];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePickerController dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)saveImage:(UIImage *)image {
    [imageView setImage:image];
    selectImage= image;
}

- (void)showAlbum
{
	if (imagePickerController == nil)
	{
        imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
    }
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePickerController animated:YES];
}


-(void)clickBack{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)clickCheckIn{
   
    FMDatabase *db= [ViewController getUserDataBase];
    if ([db open]) {
   // time integer , description text,imagename   blob
        NSString *sql = @"insert into checkin (poiid,time,description,imagename) values (?,?,?,?)";
        NSString *description=[contentTextFeil text];
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
      //   NSLog(@"interval==%d", interval);
        NSInteger time = interval;
        
      //  long long int date = (long long int)time;
        NSLog(@"time==%d", time);
        [db executeUpdate:sql,poiid, [NSString stringWithFormat:@"%d", time],description,UIImagePNGRepresentation(selectImage)];
        NSString *poi_checkin=NSLocalizedStringFromTable(@"poi_checkin", @"InfoPlist",nil);
        if ([db hadError])
        {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                              message:[[NSString alloc]initWithFormat:@"%@失败",poi_checkin]  
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
            [alertView show];
        }else{
            NSString *qiandao;
            NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userimage.png"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
                NSString *poi_faourite_success=NSLocalizedStringFromTable(@"poi_faourite_success", @"InfoPlist",nil);
                
                qiandao=poi_faourite_success;
            }else{
                qiandao=[[NSString alloc]initWithFormat:@"%@成功，登陆以后可以同步到微博",poi_checkin];
            }
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                               message:qiandao
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
            [alertView show];
        }
    }
    [db close];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self clickBack];
}


- (void)viewDidUnload
{
    [self setLabelText:nil];
    [self setContentTextFeil:nil];
    [self setPaizhaoButton:nil];
    [self setXiangceButton:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidChange:(UITextView  *)textVIew{
    if([textVIew.text length]>0){
        [labelText setHidden:YES];
    }else{
         [labelText setHidden:NO];
    }
}

@end
