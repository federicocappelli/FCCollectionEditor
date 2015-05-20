//
//  ViewController.m
//  FCDictionaryEditorSample
//
//  Created by Federico Cappelli on 20/05/2015.
//  Copyright (c) 2015 Federico Cappelli. All rights reserved.
//

#import "ViewController.h"
#import "FCCollectionEditorViewController.h"

@interface ViewController ()

@property(nonatomic, strong) id dataModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editArrayHandler:(id)sender
{
    _dataModel = @[
                   @"Federico Cappelli",
                   @(31),
                   @(YES),
                   @{@"key 1":@(1), @"Key 2":@"value 2"},
                   @[@"A",@"B",@"C",@"D",@"E"],
                   ];
    
    FCCollectionEditorViewController * vc = [[FCCollectionEditorViewController alloc] init];
    [vc setDataModelObject:_dataModel];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)editDictionaryHandler:(id)sender
{
    _dataModel = @{
                   @"Name":@"Federico Cappelli",
                   @"Age":@(31),
                   @"Boolean":@(YES),
                   @"Random Dictionary":@{@"key 1":@(1), @"Key 2":@"value 2"},
                   @"Random Array":@[@"A",@"B",@"C",@"D",@"E"],
                   @"Random Set": [NSSet setWithObjects:@"Obj 1",@"Obj 2",@"Obj 3",@"Obj 4", nil] ,
                   };
    
    FCCollectionEditorViewController * vc = [[FCCollectionEditorViewController alloc] init];
    [vc setDataModelObject:_dataModel];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FCCollectionEditorDelegate

-(void)fcCollectionEditorDidChangeDataModelObject:(id)editedObj original:(id)originalObj
{
    NSLog(@"Data model did change");
    //    NSLog(@"Original: %@",originalObj);
    //    NSLog(@"Edited: %@",editedObj);
    
    _dataModel = editedObj; //now mutable
}



@end
