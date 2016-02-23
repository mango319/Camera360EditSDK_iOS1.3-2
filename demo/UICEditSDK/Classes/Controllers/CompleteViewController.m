//
//  CompleteViewController.m
//  UICEditSDK
//
//  Created by Cc on 15/1/12.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import "CompleteViewController.h"
#import "UICDisplayImageView.h"
#import "UICButton.h"

@interface CompleteViewController ()

@property (nonatomic,weak) IBOutlet UIView *mV_topView;
@property (nonatomic,weak) IBOutlet UICButton *mV_endButton;
@property (nonatomic,weak) IBOutlet UICDisplayImageView *mV_displayImageView;

@property (nonatomic,strong) UIImage *mImageOri;
@property (nonatomic,strong) UIImage *mImagePre;

@end

@implementation CompleteViewController

+ (instancetype)sCreateSelfWithDelegate:(id<CompleteViewControllerDelegate>)delegate
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CompleteViewController *vCtl = [storyBoard instantiateViewControllerWithIdentifier:@"CompleteViewController"];
    if ([vCtl isKindOfClass:[CompleteViewController class]]) {
        
        vCtl.dgDelegate = delegate;
        return vCtl;
    }
    return nil;
}

+ (instancetype)sCreateSelf
{
    return [self sCreateSelfWithDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mV_displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mV_displayImageView pSetupOrigImage:self.mImageOri];
    [self.mV_displayImageView pSetupPreviewImage:self.mImagePre];
    
    [self.mV_endButton pSetupTitle:NSLocalizedString(@"UICEditSDK_EditAgain"
                                                     , @"再次编辑")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_mV_endButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
}

- (IBAction)onClickForEnd:(id)sender
{
    if (self.dgDelegate && [self.dgDelegate respondsToSelector:@selector(dgCompleteViewController_complete:)]) {
        
        [self.dgDelegate dgCompleteViewController_complete:self];
    }
}


- (void)pSetupOrigImage:(UIImage *)oImage withPreImage:(UIImage *)pImage
{
    self.mImageOri = oImage;
    self.mImagePre = pImage;
}
@end
