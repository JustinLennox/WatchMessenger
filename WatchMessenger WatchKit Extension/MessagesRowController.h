//
//  MessagesRowController.h
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;

@interface MessagesRowController : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceGroup *messageGroup;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *messageLabel;

@end
