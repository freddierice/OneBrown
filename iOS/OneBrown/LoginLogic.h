//
//  LoginLogic.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginLogic : NSObject

+ (BOOL)validateUsername: (NSString *)username;
+ (BOOL)validatePassword: (NSString *)password;
+ (BOOL)validateEmail: (NSString *)email;

@end
