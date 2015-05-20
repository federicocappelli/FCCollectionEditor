#FCCollectionEditor
FCCollectionEditor view controller is a fast and ready to use recursive way to edit many Collection types provided by Foundation framework.

Screenshots:
![Screenshot 1](/FCCollectionEditorSample/Screenshots/screenshot1.png)
![Screenshot 2](/FCCollectionEditorSample/Screenshots/screenshot2.png)

## Foundation classes supported (+mutable versions):
 * NSArray
 * NSDictionary
 * NSSet
 * NSNumber
 * NSString


Functions: edit and delete values

## How to use:
Have a look to the **FCCollectionEditorSample** provided.

## Steps
 1. #import "FCCollectionEditorViewController.h"
 2. Implement FCCollectionEditorDelegate
 3. Create and push the FCCollectionEditor

```Objective-c
NSDictionary * dataModel = @{
    @"Name":@"Federico Cappelli",
    @"Age":@(31),
    @"Boolean":@(YES),
    @"A Dictionary" : @{@"key 1":@(1), @"Key 2":@"value 2"},
    @"An Array" : @[@"A",@"B",@"C",@"D",@"E"],
    @"A Set": [NSSet setWithObjects:@"Obj 1",@"Obj 2",@"Obj 3",@"Obj 4", nil] ,
}

FCCollectionEditorViewController * vc = [[FCCollectionEditorViewController alloc] init];
[vc setDataModelObject:dataModel];
vc.delegate = self;
[self.navigationController pushViewController:vc animated:YES];
```