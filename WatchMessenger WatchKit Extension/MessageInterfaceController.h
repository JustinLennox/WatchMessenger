//
//  MessageInterfaceController.h
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "MessagesRowController.h"
#import "Message.h"

@interface MessageInterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *replyButton;
- (IBAction)replyButtonPressed;
@property (strong, nonatomic) NSMutableDictionary *messagesDictionary;

@property (strong, nonatomic) NSMutableArray *conversationArray;
@property (strong, nonatomic) Message *currentMessage;
@property (strong, nonatomic) NSString *currentUrgency;

@property (strong, nonatomic) IBOutlet WKInterfaceSlider *urgencySlider;
- (IBAction)urgencySliderPressed:(float)value;

@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) NSString *recipientID;

-(IBAction)niceMenuPressed:(id)sender;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *messagePreviewLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *sendButton;
- (IBAction)sendButtonPressed;

@property (strong, nonatomic) Message *mostRecentMessage;

@property (strong, nonatomic) CLLocationManager *locationManager;



@end
