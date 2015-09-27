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
    [self.messagePreviewLabel setHidden:YES];
    self.currentUrgency = @"Not Urgent";
    
    NSTimer *refresh = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(railsLoadMessages) userInfo:nil repeats:true];
    
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
    self.sending = true;
    [self.table setHidden:YES];
    
    NSArray* initialPhrases = [self getInitialPhrases];
    [self presentTextInputControllerWithSuggestions:initialPhrases
                                   allowedInputMode:WKTextInputModePlain
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
                                                 [self.table setHidden:NO];
                                                 [self.messagePreviewLabel setHidden:YES];
                                                 [self.urgencySlider setHidden:YES];
                                                 [self.sendButton setHidden:YES];
                                                 [self.replyButton setHidden:NO];
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
        [self.urgencySlider setColor:[UIColor orangeColor]];
        self.currentUrgency = @"Important";
    }else if(value == 3){
        [self.urgencySlider setColor:[UIColor magentaColor]];
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
    [self.table setNumberOfRows:self.conversationArray.count withRowType:@"messageRow"];
    for(int i = 0; i < self.conversationArray.count; i++){
        MessagesRowController *row = [self.table rowControllerAtIndex:i];
        Message *currentMessage = [self.conversationArray objectAtIndex:i];
        [row.messageLabel setText:currentMessage.messageText];
        [row.messageGroup setBackgroundColor:[UIColor blackColor]];
        if(currentMessage.urgency){
            if([currentMessage.senderID containsString: self.deviceID]){
                [row.messageLabel setHorizontalAlignment:WKInterfaceObjectHorizontalAlignmentRight];
                if([currentMessage.urgency isEqualToString:@"Urgent"]){
                    [row.messageGroup setBackgroundImageNamed:@"UrgentMessage"];
                    
                }else if([currentMessage.urgency isEqualToString:@"Not Urgent"]){
                    [row.messageGroup setBackgroundImageNamed:@"NotUrgentMessage"];
                    
                }else if([currentMessage.urgency isEqualToString:@"Important"]){
                    [row.messageGroup setBackgroundImageNamed:@"ImportantMessage"];
                    
                }else if([currentMessage.urgency isEqualToString:@"LifeOrDeath"]){
                    [row.messageGroup setBackgroundImageNamed:@"LifeOrDeathMessage"];
                    
                }

            }else if(![currentMessage.senderID containsString:self.deviceID]){
                [row.messageLabel setHorizontalAlignment:WKInterfaceObjectHorizontalAlignmentLeft];

                if([currentMessage.urgency isEqualToString:@"Urgent"]){
                    [row.messageGroup setBackgroundImageNamed:@"UrgentReply"];
                }else if([currentMessage.urgency isEqualToString:@"Not Urgent"]){
                    
                    [row.messageGroup setBackgroundImageNamed:@"NotUrgentReply"];
                    
                }else if([currentMessage.urgency isEqualToString:@"Important"]){
                    
                    [row.messageGroup setBackgroundImageNamed:@"ImportantReply"];
                    
                }else if([currentMessage.urgency isEqualToString:@"LifeOrDeath"]){
                    
                    [row.messageGroup setBackgroundImageNamed:@"LifeOrDeathReply"];
                    
                }

            }else{
                NSLog(@"HUH?@??!!");
            }

        }
        
        if(i == self.conversationArray.count - 1 && self.sending == false && ![self.lastBuzzedMessage isEqualToString:currentMessage.messageText]){
            self.lastBuzzedMessage = currentMessage.messageText;
            if([currentMessage.urgency isEqualToString:@"Not Urgent"]){
                [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeClick];
            }else if([currentMessage.urgency isEqualToString:@"Important"]){
                [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeNotification];
            }else if([currentMessage.urgency isEqualToString:@"Urgent"]){
                [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeStop];
            }else if([currentMessage.urgency isEqualToString:@"LifeOrDeath"]){
                [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeFailure];
            }
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
    self.sending = false;
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

//-(void)railsSendMessage{
//    NSMutableDictionary *dict = @{
//                                  @"message":@{
//                                          @"senderID":self.currentMessage.senderID,
//                                          @"messageText":self.currentMessage.messageText,
//                                          @"receiverID":self.currentMessage.receiverID,
//                                          @"urgency":self.currentMessage.urgency
//                                          }
//                                  }.mutableCopy;
//    
//    NSError *serr;
//    
//    NSData *jsonData = [NSJSONSerialization
//                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
//    
//    if (serr)
//    {
//        NSLog(@"Error generating json data for send dictionary...");
//        NSLog(@"Error (%@), error: %@", dict, serr);
//        return;
//    }
//    
//    NSLog(@"Successfully generated JSON for send dictionary");
//    NSLog(@"now sending this dictionary...\n%@\n\n\n", dict);
//    
//    NSURL *appService = [NSURL URLWithString:@"https://salty-lake-8662.herokuapp.com/messages.json"];
//    
//    // Create request object
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
//    
//    // Set method, body & content-type
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = jsonData;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    [request setValue:
//     [NSString stringWithFormat:@"%lu",
//      (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
//     {
//         
//         if (!data)
//         {
//             NSLog(@"No data returned from server, error ocurred: %@", error);
//             NSString *userErrorText = [NSString stringWithFormat:
//                                        @"Error communicating with server: %@", error.localizedDescription];
//             return;
//         }
//         
//         NSLog(@"got the NSData fine. here it is...\n%@\n", data);
//         NSLog(@"next step, deserialising");
//         
//         NSError *deserr;
//         NSDictionary *responseDict = [NSJSONSerialization
//                                       JSONObjectWithData:data
//                                       options:kNilOptions
//                                       error:&deserr];
//         
//         NSLog(@"so, here's the responseDict\n\n\n%@\n\n\n", responseDict);
//         // LOOK at that output on your console to learn how to parse it.
//         // to get individual values example blah = responseDict[@"fieldName"];
//     }];
//
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
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString: @"https://salty-lake-8662.herokuapp.com/messages.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(response){
            [self railsLoadMessages];
        }
        
    }];
    
    [postDataTask resume];
}


-(void)railsLoadMessages{
    Message *lastMessage = [[Message alloc] init];
    if(self.conversationArray.count >= 1){
        lastMessage = [self.conversationArray objectAtIndex:self.conversationArray.count - 1];
    }
    self.conversationArray = [NSMutableArray arrayWithArray:@[]];
    NSString *venueURL = @"https://salty-lake-8662.herokuapp.com/messages.json";   //Send a GET to the backend at /users/fbUser/fbAcessToken
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
    
    NSArray *jsonArray;
    NSError *e = nil;

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:venueURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSString *json = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

                if([json containsString:@"]["]){
                    NSRange range = [json rangeOfString:@"]["];
                    json = [json substringToIndex:range.location + 1];
                }

                NSData *stringData = [json dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:stringData options: NSJSONReadingMutableContainers error:&error];
                
                if (!jsonArray) {
                    //This user hasn't been signed up yet. Creating a new user.
                } else {
                    for(NSDictionary *messageDict in jsonArray){
                        Message *message = [[Message alloc] init];
                        message.senderID = [messageDict objectForKey:@"senderID"];
                        message.receiverID = [messageDict objectForKey:@"receiverID"];
                        message.messageText = [messageDict objectForKey:@"messageText"];
                        message.urgency = [messageDict objectForKey:@"urgency"];
                        [self.conversationArray addObject:message];
                    }
                    Message *latestMessage = [self.conversationArray objectAtIndex:self.conversationArray.count - 1];
                    if(![latestMessage.messageText isEqualToString:self.lastBuzzedMessage]){
                        [self loadMessagesIntoTable];
                    }
                    
                    
                }
                if(error){
                    NSLog(@"%@",error);
                }
 // handle response
                
            }] resume];
//    NSData *response1 =
//    [NSURLConnection sendSynchronousRequest:request
//                          returningResponse:&urlResponse error:&requestError];
//    
//    
//    
//    if(response1){
//        jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options: NSJSONReadingMutableContainers error: &e];
//        
//        if (!jsonArray) {
//            //This user hasn't been signed up yet. Creating a new user.
//            NSLog(@"No json array");
//        } else {
//            for(NSDictionary *messageDict in jsonArray){
//                Message *message = [[Message alloc] init];
//                message.senderID = [messageDict objectForKey:@"senderID"];
//                message.receiverID = [messageDict objectForKey:@"receiverID"];
//                message.messageText = [messageDict objectForKey:@"messageText"];
//                message.urgency = [messageDict objectForKey:@"urgency"];
//                [self.conversationArray addObject:message];
//            }
//            [self loadMessagesIntoTable];
//            
//        }
//        
//        
//    }else{
//        NSLog(@"%@", requestError);
//    }
//
}

-(NSArray *)getInitialPhrases{
    NSString *messageText = self.mostRecentMessage.messageText;
    NSMutableArray *tempPhrases = [[NSMutableArray alloc] init];
    self.mostRecentMessage = [self.conversationArray objectAtIndex:self.conversationArray.count - 1];

    if([self.mostRecentMessage.urgency isEqualToString:@"Not Urgent"]){
        for(Message *m in self.conversationArray){
            if([m.senderID isEqualToString:self.deviceID] && [m.urgency isEqualToString:@"Not Urgent"]){
                [tempPhrases addObject:m.messageText];
            }
        }
        [tempPhrases addObjectsFromArray:@[@"Hey", @"How's it going?", @"What's up?", @"I'm good!", @"Where are you?"]];

        if([messageText containsString:@"Where"]){
            [tempPhrases addObjectsFromArray:@[@"At home", @"Just chillin'", @"At the office"]];
        }else if([messageText containsString:@"goin"] || [messageText containsString:@"How"] || [messageText containsString:@"you"]){
            [tempPhrases addObjectsFromArray: @[@"Pretty good, you?", @"Not bad", @"Alright"]];
        }
    }else if([self.mostRecentMessage.urgency isEqualToString:@"Important"]){
        for(Message *m in self.conversationArray){
            if([m.senderID isEqualToString:self.deviceID] && [m.urgency isEqualToString:@"Important"]){
                [tempPhrases addObject:m.messageText];
            }

        }
        
        [tempPhrases addObjectsFromArray:@[@"We need to talk", @"Call me when you can", @"Are you free?", @"Where are you?"]];
    }else if([self.mostRecentMessage.urgency isEqualToString:@"Urgent"]){
        for(Message *m in self.conversationArray){
            if([m.senderID isEqualToString:self.deviceID] && [m.urgency isEqualToString:@"Urgent"]){
                [tempPhrases addObject:m.messageText];
            }
        }
        [tempPhrases addObjectsFromArray:@[@"We need to talk ASAP", @"Call me as soon as possible", @"Where are you? It's urgent"]];
    }else if([self.mostRecentMessage.urgency isEqualToString:@"LifeOrDeath"]){
        for(Message *m in self.conversationArray){
            if([m.senderID isEqualToString:self.deviceID] && [m.urgency isEqualToString:@"Urgent"]){
                [tempPhrases addObject:m.messageText];
            }
        }
        [tempPhrases addObjectsFromArray:@[@"LAT: 33.7762990; LONG:-84.3960080", @"I'm safe", @"I'm in trouble", @"I'm OK"]];
    }
    NSCountedSet *countedSet = [NSCountedSet setWithArray:tempPhrases];
    NSMutableArray *finalArray = [NSMutableArray arrayWithCapacity:[tempPhrases count]];
    
    for(id obj in countedSet) {
        if([countedSet countForObject:obj] == 1) {
            [finalArray addObject:obj];
        }
    }
    NSArray *phrasesArray = [NSArray arrayWithArray:finalArray];
    
    return phrasesArray;
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}


@end



