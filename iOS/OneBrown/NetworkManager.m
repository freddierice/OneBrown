//
//  NetworkManager.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/5/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

@synthesize messages, additionalDelegates, outputStream, inputStream, data, host, port;

+(NetworkManager *)networkManagerWithHost:(CFStringRef)host port:(UInt32)port {
    
    NetworkManager *manager = [NetworkManager new];
    
    manager.host = host;
    manager.port = port;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(Nil, host, port, &readStream, &writeStream);
    
    manager.outputStream = (__bridge NSOutputStream *)writeStream;
    manager.inputStream = (__bridge NSInputStream *)readStream;
    
    manager.outputStream.delegate = manager;
    manager.inputStream.delegate = manager;
    
    manager.data = [NSMutableData data];
    manager.messages = [NSMutableArray array];
    
    [manager addObserver:manager forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:NULL];
    
    return manager;
}

-(void)reopenConnection {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(Nil, host, port, &readStream, &writeStream);
    
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    self.inputStream = (__bridge NSInputStream *)readStream;
    
    self.outputStream.delegate = self;
    self.inputStream.delegate = self;
    
}

-(void)open {
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.outputStream open];
    [self.inputStream open];
}

-(BOOL)writeData:(NSData *)msg {
    
    NSUInteger written = [self.outputStream write:[msg bytes] maxLength:[msg length]];
    return written == [msg length];
}

-(void)appendBytes: (const void *)bytes length:(NSUInteger)length {
    [self willChangeValueForKey:@"data"];
    [self.data appendBytes:bytes length:length];
    [self didChangeValueForKey:@"data"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"data"] && self.data.length > 0) {
        
        NSError *e;
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&e];
        
        [self.messages addObject:JSON];
        
        [self.delegate didReceiveJSON:JSON];
        
        for (id object in self.additionalDelegates) {
            if ([object conformsToProtocol:@protocol(NetworkManagerDelegate)]) {
                [object didReceiveJSON:JSON];
            }
        }
        
        self.data = [NSMutableData data];
        
    }
    
}

#pragma mark - NSStreamDelegate protocol implementation

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
            
        case NSStreamEventOpenCompleted: {
            
            NSLog(@"Opened");
            
            break;
        }
            
        case NSStreamEventHasBytesAvailable: {
            if (!self.data) {
                self.data = [NSMutableData data];
            }
            
            if (aStream == self.inputStream) {
                
                uint8_t buffer[1024];
                long len;
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        [self appendBytes:buffer length:len];
                    }
                }
            }
            
            break;
        }
            
        case NSStreamEventHasSpaceAvailable: {
            break;
        }
            
        case NSStreamEventErrorOccurred: {
            NSLog(@"%@",[aStream streamError]);
            break;
        }
            
        case NSStreamEventEndEncountered: {
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
            
        default: {
            break;
        }
    }
}

@end
