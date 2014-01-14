//
//  NetworkManager.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/5/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkManager;

@protocol NetworkManagerDelegate <NSObject>

@required
-(void)didReceiveJSON:(NSDictionary *)JSON;

@end

@interface NetworkManager : NSObject <NSStreamDelegate>	 {
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableData *data;
    
    NSMutableArray *messages;
    
    CFStringRef host;
    UInt32 port;
    
    NSMutableArray *additionalDelegates;
    
}

@property (nonatomic, retain) NSMutableArray *additionalDelegates;

@property (nonatomic, assign) CFStringRef host;
@property (nonatomic, assign) UInt32 port;

@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) NSMutableData *data;

@property (nonatomic, weak) id <NetworkManagerDelegate> delegate;

+(NetworkManager*)networkManagerWithHost: (CFStringRef)host port: (UInt32)port;

-(void)open;

-(BOOL)writeData: (NSData *)msg;

@end
