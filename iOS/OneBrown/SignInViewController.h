//
//  SignInViewController.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate, NSStreamDelegate> {

    UIView *overlayView;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableData *data;
    NSData *dataToWrite;
    
    NSUInteger byteIndex;
}

@property (nonatomic, assign) NSUInteger byteIndex;

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSData *dataToWrite;

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

@property (nonatomic, retain) UIView *overlayView;

@property (nonatomic, weak) UIButton *signInButton;
@property (nonatomic, weak) UITextField *userField;
@property (nonatomic, weak) UITextField *passField;

@end
