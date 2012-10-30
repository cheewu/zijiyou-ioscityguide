//
//  CheckInViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-16.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>{
    UIImagePickerController *imagePickerController;
    UIImagePickerController *albumPicker;
    UIImagePickerControllerSourceType currentSourceType;
    UIImage *selectImage;
    NSString *poiid;
}
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UITextView *contentTextFeil;
@property (weak, nonatomic) IBOutlet UIButton *paizhaoButton;
@property (weak, nonatomic) IBOutlet UIButton *xiangceButton;
@property (nonatomic,retain) NSMutableDictionary *poiData;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
