The Collection editor view controller is a fast and ready to use recursive way to edit many Collection types provided by Foundation framework.
 
 Foundation classes supported (mutable version included):
 - NSArray
 - NSDictionary
 - NSSet
 - NSNumber
 - NSString
 
Functions: edit and delete values

 Collection example:
 
 NSDictionary * dataModel = @{
 @"Name":@"Federico Cappelli",
 @"Age":@(31),
 @"Boolean":@(YES),
 @"A Dictionary" : @{@"key 1":@(1), @"Key 2":@"value 2"},
 @"An Array" : @[@"A",@"B",@"C",@"D",@"E"],
 @"A Set": [NSSet setWithObjects:@"Obj 1",@"Obj 2",@"Obj 3",@"Obj 4", nil] ,
 }