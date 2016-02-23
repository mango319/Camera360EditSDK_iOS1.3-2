//
//  MainViewController.m
//  UICEditSDK
//
//  Created by Cc on 15/1/10.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import "MainViewController.h"
#import "SVProgressHUD.h"
#import "UICDisplayImageView.h"
#import "UICButton.h"
#import "CompleteViewController.h"

@interface MainViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CompleteViewControllerDelegate>

/* override */
@property (nonatomic,assign) eMainViewControllerState mState;
/* override */

/* IBOutlet */
@property (nonatomic,weak) IBOutlet UIView *mV_topView;
@property (nonatomic,weak) IBOutlet UICButton *mV_chooseButton;
@property (nonatomic,weak) IBOutlet UICButton *mV_editButton;
@property (nonatomic,weak) IBOutlet UICDisplayImageView *mV_displayImageView;

@property (nonatomic,strong) UIPopoverController *mPopoverController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupState:eMainViewControllerState_init];
    
    [self.mV_chooseButton pSetupTitle:NSLocalizedString(@"UICEditSDK_ChooseImages"
                                                        , @"选择照片")];
    [self.mV_editButton pSetupTitle:NSLocalizedString(@"UICEditSDK_Edit"
                                                      , @"编辑")];
    
    //设置颜色
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:6];
    [SVProgressHUD setCornerRadius:16];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_mV_editButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [_mV_chooseButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
}

//设置当前状态
- (void)setupState:(eMainViewControllerState)eState
{
    [self setupStateForTopView:eState];
    [self setupStateForEditButton:eState];
    [self setupStateForDisplay:eState];
}

- (void)setupStateForTopView:(eMainViewControllerState)eState
{
    switch (eState) {
        case eMainViewControllerState_init:
        {
            self.mV_topView.hidden = YES;
        }
            break;
            
        default:
        {
            self.mV_topView.hidden = NO;
        }
            break;
    }
}

- (void)setupStateForEditButton:(eMainViewControllerState)eState
{
    switch (eState) {
        case eMainViewControllerState_init:
        {
            self.mV_editButton.enabled = NO;
        }
            break;
            
        default:
        {
            self.mV_editButton.enabled = YES;
        }
            break;
    }
}

- (void)setupStateForDisplay:(eMainViewControllerState)eState
{
    switch (eState) {
        case eMainViewControllerState_init:
        {
            self.mV_displayImageView.contentMode = UIViewContentModeCenter;
            self.mV_displayImageView.image = [UIImage imageNamed:@"sdk_logo"];
            self.mV_displayImageView.userInteractionEnabled = NO;
        }
            break;
            
        default:
        {
            self.mV_displayImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.mV_displayImageView.userInteractionEnabled = YES;
        }
            break;
    }
}

- (IBAction)onClickForChooseButton:(id)sender
{
    //点击选择照片按钮，打开系统选择UI
    [self pPresentAUIImagePickerController];
}

- (IBAction)onClickForEditButton:(id)sender
{
    [self pPushPGEditSDKController];
}

#pragma mark - navigationController
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]]
        && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

#pragma mark - UIImagePickerController
- (void)pPresentAUIImagePickerController
{
    UIUserInterfaceIdiom dType = UI_USER_INTERFACE_IDIOM();
    switch (dType) {
        case UIUserInterfaceIdiomPhone:
        {
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //model 一个 View
                [self presentViewController:picker animated:YES completion:^{
                    
                    NSLog(@"选择照片..");
                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                }];
            }
            else {
                NSAssert(NO, @" ");
            }
        }
            break;
        case UIUserInterfaceIdiomPad:
        {
            if (self.mPopoverController) {
                
                [self.mPopoverController presentPopoverFromRect:self.mV_chooseButton.frame inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionAny) animated:YES];
            }
            else {
                
                if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    self.mPopoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
                    
                    [self.mPopoverController presentPopoverFromRect:self.mV_chooseButton.frame
                                                             inView:self.view
                                           permittedArrowDirections:(UIPopoverArrowDirectionAny)
                                                           animated:YES];
                }
                else {
                    NSAssert(NO, @" ");
                }
            }
        }
            break;
            
        default:
            NSAssert(NO, @"");
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSAssert(image, @" ");
    if (image) {
        
        [self setupState:eMainViewControllerState_choosed];
        [self.mV_displayImageView pSetupOrigImage:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - pg_edit_sdk_controller
- (void)pPushPGEditSDKController
{
    pg_edit_sdk_controller *editCtl = nil;
    {
        //构建编辑对象    Construct edit target
        pg_edit_sdk_controller_object *obje = [[pg_edit_sdk_controller_object alloc] init];
        {
            //输入原图  Input original
            obje.pCSA_fullImage = [self.mV_displayImageView.mOrigImage copy];
        }
        editCtl = [[pg_edit_sdk_controller alloc] initWithEditObject:obje withDelegate:self];
    }
    NSAssert(editCtl, @"Error");
    if (editCtl) {
        
        [self.navigationController pushViewController:editCtl animated:YES];
        
        /*
        [self presentViewController:editCtl animated:YES completion:^{
            //do nothing
         }];
         */
    }
}

- (void)dgPhotoEditingViewControllerDidCancel:(UIViewController *)pController withClickSaveButton:(BOOL)isClickSaveBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dgPhotoEditingViewControllerDidFinish:(UIViewController *)pController
                                       object:(pg_edit_sdk_controller_object *)pOjbect
{
    //获取效果小图    Obtain effect thumbnail
    UIImage *image = [UIImage imageWithData:pOjbect.pOutEffectDisplayData];
    NSAssert(image, @" ");
    [self.mV_displayImageView pSetupPreviewImage:image];
    //启动一个完成界面  Start a completed screen
    [self pPushCompleteViewController];
    
    //获取效果大图    Obtain effect large image
    UIImage *imageOri = [UIImage imageWithData:pOjbect.pOutEffectOriData];
    NSAssert(imageOri, @" ");
    //保存到相册     Save to album
    UIImageWriteToSavedPhotosAlbum(imageOri, nil, NULL, NULL);
}

- (void)dgPhotoEditingViewControllerShowLoadingView:(UIView *)view
{
    [SVProgressHUD show];
}

- (void)dgPhotoEditingViewControllerHideLoadingView:(UIView *)view
{
    [SVProgressHUD dismiss];
}


#pragma mark - CompleteViewController
- (void)pPushCompleteViewController
{
    [self performSegueWithIdentifier:@"segueComplete" sender:self];
}

- (void)dgCompleteViewController_complete:(CompleteViewController *)vc
{
    [self setupState:eMainViewControllerState_init];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CompleteViewController *ctl = segue.destinationViewController;
    if ([ctl isKindOfClass:[CompleteViewController class]]) {
        
        ctl.dgDelegate = self;
        [ctl pSetupOrigImage:self.mV_displayImageView.mOrigImage withPreImage:self.mV_displayImageView.mPreviewImage];
    }
}
@end
