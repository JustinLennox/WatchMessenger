//
//  MessageInterfaceController.m
//  WatchMessenger
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import "MessageInterfaceController.h"
#import <CoreLocation/CoreLocation.h>


@interface MessageInterfaceController ()

@end

@implementation MessageInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
#if (TARGET_IPHONE_SIMULATOR)
    self.deviceID = @"Justin Lennox";
    self.recipientID = @"India Batson";
#endif
#if !(TARGET_IPHONE_SIMULATOR)
    self.deviceID = @"India Batson";
    self.recipientID = @"Justin Lennox";
#endif
    
    self.conversationArray = [[NSMutableArray alloc] init];
    [self.replyButton setTitle:@"Reply!"];
    [self.urgencySlider setHidden:YES];
    [self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"Decline" action:@selector(killSwitch)];
    [self.sendButton setHidden:YES];
    self.currentUrgency = @"Not Urgent";
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self railsLoadMessages];
    
}

-(void)killSwitch{
    NSLog(@"LILL IT");
}

- (IBAction)replyButtonPressed {
    [self.table setHidden:YES];
    
    NSArray* initialPhrases = [self getInitialPhrases];
    [self presentTextInputControllerWithSuggestions:initialPhrases
                                   allowedInputMode:WKTextInputModeAllowEmoji
                                         completion:^(NSArray *results) {
                                             if (results && results.count > 0) {
                                                 [self.urgencySlider setHidden:NO];
                                                 [self.sendButton setHidden:NO];
                                                 [self.replyButton setHidden:YES];
                                                 [self.messagePreviewLabel setHidden:NO];
                                                 self.messagePreviewLabel.text = [results objectAtIndex:0];
                                                 Message *message = [[Message alloc] init];
                                                 message.senderID = self.deviceID;
                                                 message.receiverID = self.recipientID;
                                                 message.messageText = [results objectAtIndex:0];
                                                 self.currentMessage = message;
                                                 // Use the string or image.
                                             }
                                             else {
                                                 // Nothing was selected.
                                             }
                                         }];
    
}

- (IBAction)urgencySliderPressed:(float)value {
    
    NSLog(@"Slider value: %f", value);
    if(value == 0){
        [self.urgencySlider setValue:1];
        [self.urgencySlider setColor:[UIColor greenColor]];
        self.currentUrgency = @"Not Urgent";
    }else if(value == 1){
        [self.urgencySlider setColor:[UIColor greenColor]];
        self.currentUrgency = @"Not Urgent";
    }else if(value == 2){
        [self.urgencySlider setColor:[UIColor yellowColor]];
        self.currentUrgency = @"Important";
    }else if(value == 3){
        [self.urgencySlider setColor:[UIColor orangeColor]];
        self.currentUrgency = @"Urgent";
    }else if(value == 4){
        [self.urgencySlider setColor:[UIColor redColor]];
        self.currentUrgency = @"LifeOrDeath";
    }
    
}

-(IBAction)niceMenuPressed:(id)sender{
    NSLog(@"Nice menu pressed");
}

-(void)loadMessagesIntoTable{
    [self.messagePreviewLabel setHidden:YES];
    [self.table setNumberOfRows:self.conversationArray.count withRowType:@"messageRow"];
    for(int i = 0; i < self.conversationArray.count; i++){
        MessagesRowController *row = [self.table rowControllerAtIndex:i];
        Message *currentMessage = [self.conversationArray objectAtIndex:i];
        [row.messageLabel setText:currentMessage.messageText];
        if(currentMessage.urgency){
            if([currentMessage.urgency isEqualToString:@"Urgent"]){
                [row.messageGroup setBackgroundColor:[UIColor colorWithRed:(248.0f/255.0f) green:(148.0f/255.0f) blue:(6.0f/255.0f) alpha:1.0f]];
            }else if([currentMessage.urgency isEqualToString:@"Not Urgent"]){
                [row.messageGroup setBackgroundColor:[UIColor colorWithRed:(39.0f/255.0f) green:(174.0f/255.0f) blue:(96.0f/255.0f) alpha:1.0f]];
            }else if([currentMessage.urgency isEqualToString:@"Important"]){
                [row.messageGroup setBackgroundColor:[UIColor colorWithRed:(241.0f/255.0f) green:(196.0f/255.0f) blue:(15.0f/255.0f) alpha:1.0f]];

            }else if([currentMessage.urgency isEqualToString:@"LifeOrDeath"]){
                [row.messageGroup setBackgroundColor:[UIColor colorWithRed:(192.0f/255.0f) green:(57.0f/255.0f) blue:(43.0f/255.0f) alpha:1.0f]];
            }
            if(![currentMessage.senderID isEqualToString:self.deviceID]){
                [row.messageLabel setHorizontalAlignment:WKInterfaceObjectHorizontalAlignmentCenter];
                WKInterfaceDevice *currentDevice = [WKInterfaceDevice currentDevice];
                [row.messageGroup setWidth:currentDevice.screenBounds.size.width * 0.8f];
            }else{
                [row.messageLabel setHorizontalAlignment:WKInterfaceObjectHorizontalAlignmentCenter];
                WKInterfaceDevice *currentDevice = [WKInterfaceDevice currentDevice];
                [row.messageGroup setWidth:currentDevice.screenBounds.size.width * 0.8f];
                [row.messageGroup setHorizontalAlignment:WKInterfaceObjectHorizontalAlignmentRight];
            }

        }
        
        if(i == self.conversationArray.count){
            [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeClick];
        }
    }
    [self.table scrollToRowAtIndex:self.conversationArray.count - 1];
    
}

-(void)sendMessage{
    self.currentMessage.urgency = self.currentUrgency;
    [self.table setHidden:NO];
    [self.messagePreviewLabel setHidden:YES];
    [self.urgencySlider setHidden:YES];
    [self.sendButton setHidden:YES];
    [self.replyButton setHidden:NO];
    
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)sendButtonPressed {
    [self sendMessage];
    [self railsSendMessage];
}

//-(void)railsSendMessage{
//
//    NSString *post = [NSString stringWithFormat:@"receiverID=INDIA&senderID=JUSTINLENNOX&messageText=Message&urgency=NotUrgent"];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://localhost:3000/messages.json"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:postData];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//        NSLog(@"requestReply: %@", requestReply);
//    }] resume];

//}

-(void)railsSendMessage{
    NSMutableDictionary *dict = @{
                                  @"message":@{
                                          @"senderID":self.currentMessage.senderID,
                                          @"messageText":self.currentMessage.messageText,
                                          @"receiverID":self.currentMessage.receiverID,
                                          @"urgency":self.currentMessage.urgency
                                          }
                                  }.mutableCopy;
    
    NSError *serr;
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
    
    if (serr)
    {
        NSLog(@"Error generating json data for send dictionary...");
        NSLog(@"Error (%@), error: %@", dict, serr);
        return;
    }
    
    NSLog(@"Successfully generated JSON for send dictionary");
    NSLog(@"now sending this dictionary...\n%@\n\n\n", dict);
    
    NSURL *appService = [NSURL URLWithString:@"http://localhost:3000/messages.json"];
    
    // Create request object
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
    
    // Set method, body & content-type
    request.HTTPMethod = @"POST";
    request.HTTPBody = jsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:
     [NSString stringWithFormat:@"%lu",
      (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
     {
         
         if (!data)
         {
             NSLog(@"No data returned from server, error ocurred: %@", error);
             NSString *userErrorText = [NSString stringWithFormat:
                                        @"Error communicating with server: %@", error.localizedDescription];
             return;
         }
         
         NSLog(@"got the NSData fine. here it is...\n%@\n", data);
         NSLog(@"next step, deserialising");
         
         NSError *deserr;
         NSDictionary *responseDict = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:kNilOptions
                                       error:&deserr];
         
         NSLog(@"so, here's the responseDict\n\n\n%@\n\n\n", responseDict);
         [self railsLoadMessages];
         // LOOK at that output on your console to learn how to parse it.
         // to get individual values example blah = responseDict[@"fieldName"];
     }];

}

-(void)railsLoadMessages{
    
    self.conversationArray = [NSMutableArray arrayWithArray:@[]];
    NSString *venueURL = @"http://localhost:3000/messages.json";   //Send a GET to the backend at /users/fbUser/fbAcessToken
    //Example, our user's access token is 12XY, sends request to /users/fbUser/fbAcessToken/
    
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL
                                         URLWithString:venueURL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10
     ];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse error:&requestError];
    
    
    NSError *e = nil;
    NSArray *jsonArray;
    
    if(response1){
        jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options: NSJSONReadingMutableContainers error: &e];
        
        if (!jsonArray) {
            //This user hasn't been signed up yet. Creating a new user.
            NSLog(@"No json array");
        } else {
            for(NSDictionary *messageDict in jsonArray){
                Message *message = [[Message alloc] init];
                message.senderID = [messageDict objectForKey:@"senderID"];
                message.receiverID = [messageDict objectForKey:@"receiverID"];
                message.messageText = [messageDict objectForKey:@"messageText"];
                message.urgency = [messageDict objectForKey:@"urgency"];
                [self.conversationArray addObject:message];
            }
            [self loadMessagesIntoTable];
            
        }
        
        
    }else{
        NSLog(@"We appear to be offline!");
    }

}

-(NSArray *)getInitialPhrases{
    NSLog(@"%@", [self deviceLocation]);
    self.mostRecentMessage = [self.conversationArray objectAtIndex:self.conversationArray.count - 1];
    NSArray *phrasesArray = @[@"Hey", @"How's it going?", @"What's new?"];
    if([self.mostRecentMessage.urgency isEqualToString:@"Not Urgent"]){
        if([self.mostRecentMessage.messageText containsString:@"where"]){
            NSLog(@"has love!");
            phrasesArray = @[@"At home", @"Just chillin'", @"At the office"];
        }
    }else if([self.mostRecentMessage.urgency isEqualToString:@"LifeOrDeath"]){
        if([self.mostRecentMessage.messageText containsString:@"where"]){
            phrasesArray = @[@"LAT: 33.7762990; LONG:-84.3960080", @"I'm safe'", @"I'm in trouble"];

        }
        
    }
    return phrasesArray;
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}


@end



