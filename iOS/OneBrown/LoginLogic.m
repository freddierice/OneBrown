//
//  LoginLogic.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "LoginLogic.h"

@implementation LoginLogic

+ (BOOL)validateUsername:(NSString *)username {
    
    if (username.length == 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)validatePassword:(NSString *)password {
    
    if (password.length == 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)validateEmail:(NSString *)email {
    
    if (email.length == 0) {
        return NO;
    }
    
    return YES;
}

@end
