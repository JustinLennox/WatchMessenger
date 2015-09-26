//
//  InterfaceController.m
//  WatchMessenger WatchKit Extension
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSLog(@"Awake with context");
    
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSLog(@"Will activate");
    [self.messageTable setNumberOfRows:2 withRowType:@"defaultRow"];
    MyRowController *row1 = [self.messageTable rowControllerAtIndex:0];
    [row1.senderNameLabel setText:@"Justin Lennox"];
    [row1.messageTextLabel setText:@"Hey baby it's me. I love you more than anybody on the whole planet! how've you been?"];
    [self loadMessages];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    NSLog(@"Did deactivate");
}

-(void)loadMessages{
    
    self.messagesDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"Justin Lennox":@"I love you baby! You're my best friend!", @"India Batson":@"Hey how's it going?", @"Corey Lennox":@"I play music"}];
    int keyCount = 0;
    [self.messageTable setNumberOfRows:self.messagesDictionary.count withRowType:@"defaultRow"];
    for(id key in self.messagesDictionary){
        MyRowController *row = [self.messageTable rowControllerAtIndex:keyCount];
        [row.senderNameLabel setText:[NSString stringWithFormat:@"%@",key]];
        [row.messageTextLabel setText:[self.messagesDictionary objectForKey:key]];
        keyCount++;
    }
    
}

- (IBAction)coolioPressed {
}

@end



