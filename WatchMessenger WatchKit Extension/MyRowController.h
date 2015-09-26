//
//  MyRowController.h
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagesRowController.h"
@import WatchKit;

@interface MyRowController : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *messageTextLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceSlider *contactUrgencySlider;
- (IBAction)contactUrgencySliderPressed:(float)value;


@end
