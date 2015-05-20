//
//  FCCollectionEditorViewController
//
//  Created by Federico Cappelli on 17/03/2015.
//  Copyright (c) 2015 Federico Cappelli. All rights reserved.

#import <UIKit/UIKit.h>

@protocol FCCollectionEditorDelegate <NSObject>

@optional
-(void)fcCollectionEditorDidChangeDataModelObject:(id)editedObj original:(id)originalObj;

@end

@interface FCCollectionEditorViewController : UITableViewController <UITextFieldDelegate, FCCollectionEditorDelegate>

@property(nonatomic, unsafe_unretained) id<FCCollectionEditorDelegate>delegate;

-(void)setDataModelObject:(id)dataModelObject;

@end
