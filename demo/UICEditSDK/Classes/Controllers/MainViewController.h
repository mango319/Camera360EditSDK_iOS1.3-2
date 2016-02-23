//
//  MainViewController.h
//  UICEditSDK
//
//  Created by Cc on 15/1/10.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotoEditFramework/PhotoEditFramework.h>

typedef NS_ENUM(NSUInteger, eMainViewControllerState) {
    eMainViewControllerState_init,
    eMainViewControllerState_choosed,
    eMainViewControllerState_complate,
};

@interface MainViewController : UIViewController <pg_edit_sdk_controller_delegate>

@property (nonatomic,assign,readonly) eMainViewControllerState mState;

@end
