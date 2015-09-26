//
//  Message.h
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *messageText;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *receiverID;
@property (strong, nonatomic) NSString *urgency;

@end
