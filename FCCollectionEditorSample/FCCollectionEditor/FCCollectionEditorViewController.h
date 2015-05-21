//
//  FCCollectionEditorViewController
//
//  Created by Federico Cappelli on 17/03/2015.
//  Copyright (c) 2015 Federico Cappelli. All rights reserved.

#import <UIKit/UIKit.h>

@protocol FCCollectionEditorDelegate <NSObject>

@optional
/**
 *  The data model is changed
 *
 *  @param editedObj   The modified data model
 *  @param originalObj The original data model provided
 */
-(void)fcCollectionEditorDidChangeDataModelObject:(id)editedObj original:(id)originalObj;

@end

@interface FCCollectionEditorViewController : UITableViewController <UITextFieldDelegate, FCCollectionEditorDelegate>

@property(nonatomic, unsafe_unretained) id<FCCollectionEditorDelegate>delegate;

/**
 *  Ste the data model collection
 *
 *  @param dataModelObject Collection, like: NSDictionary, NSArray, NSSet...
 */
-(void)setDataModelObject:(id)dataModelObject;

@end
