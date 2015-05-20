//
//  ViewController.h
//  FCDictionaryEditorSample
//
//  Created by Federico Cappelli on 20/05/2015.
//  Copyright (c) 2015 Federico Cappelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCCollectionEditorViewController.h"

@interface ViewController : UIViewController <FCCollectionEditorDelegate>

-(IBAction)editArrayHandler:(id)sender;
-(IBAction)editDictionaryHandler:(id)sender;

@end

