//
//  CompleteViewController.h
//  UICEditSDK
//
//  Created by Cc on 15/1/12.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompleteViewController;

@protocol CompleteViewControllerDelegate <NSObject>

- (void)dgCompleteViewController_complete:(CompleteViewController*)vc;

@end

@interface CompleteViewController : UIViewController

+ (instancetype)sCreateSelf;
+ (instancetype)sCreateSelfWithDelegate:(id<CompleteViewControllerDelegate>)delegate;

@property (nonatomic,weak) id<CompleteViewControllerDelegate> dgDelegate;

- (void)pSetupOrigImage:(UIImage*)oImage withPreImage:(UIImage*)pImage;

@end
