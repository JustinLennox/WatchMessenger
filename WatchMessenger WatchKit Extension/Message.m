//
//  Message.m
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import "Message.h"

@implementation Message

- (NSString *)description {
    return [NSString stringWithFormat: @"Message: Sender:%@, Receiver=%@, Text:%@, Urgency:%@", self.senderID, self.receiverID, self.messageText, self.urgency];
}

@end
