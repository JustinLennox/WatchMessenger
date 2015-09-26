//
//  InterfaceController.h
//  WatchMessenger WatchKit Extension
//
//  Created by Justin Lennox on 9/25/15.
//  Copyright © 2015 Justin Lennox. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "MyRowController.h"

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceTable *messageTable;
@property (strong, nonatomic) NSMutableDictionary *messagesDictionary;
- (IBAction)coolioPressed;

@end
