//
//  FCCollectionEditorViewController
//
//  Created by Federico Cappelli on 17/03/2015.
//  Copyright (c) 2015 Federico Cappelli. All rights reserved.
//

#import "FCCollectionEditorViewController.h"
#import "FCTableViewCell.h"

@interface FCCollectionEditorViewController ()
{
    NSArray * _keys;
}

@property(nonatomic, strong) id dataModelObjectOriginal;
@property(nonatomic, strong) id dataModelObjectMutableCopy;

@end

@implementation FCCollectionEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FCTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"FCTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(editHandler:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)setDataModelObject:(id)dataModelObject
{
    self.dataModelObjectMutableCopy = [dataModelObject mutableCopy];
    self.dataModelObjectOriginal = dataModelObject;
    [self configureData];
}

-(void)configureData
{
    if([self isDictionary:_dataModelObjectMutableCopy])
    {
        _keys = [[_dataModelObjectMutableCopy allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        self.title = [NSString stringWithFormat:@"Dictionary (%ld)",_keys.count];
    }
    else if([self isArray:_dataModelObjectMutableCopy])
    {
        _keys = _dataModelObjectMutableCopy;
        self.title = [NSString stringWithFormat:@"Array (%ld)",_keys.count];
    }
    else if([self isSet:_dataModelObjectMutableCopy])
    {
        _keys = [_dataModelObjectMutableCopy allObjects];
        self.title = [NSString stringWithFormat:@"Set (%ld)",_keys.count];
    }
}

#pragma mark - Private Table utilies

-(id)valueForIndex:(NSUInteger)index
{
    id result = nil;
    if([self isDictionary:_dataModelObjectMutableCopy])
    {
        NSString * key = _keys[index];
        result = [_dataModelObjectMutableCopy objectForKey:key];
    }
    else if([self isArray:_dataModelObjectMutableCopy] || [self isSet:_dataModelObjectMutableCopy])
    {
        result = _keys[index];
    }
    return result;
}

-(id)nameForIndex:(NSUInteger)index
{
    NSString * result = nil;
    if([self isDictionary:_dataModelObjectMutableCopy])
    {
        result = _keys[index];
    }
    else if([self isArray:_dataModelObjectMutableCopy] || [self isSet:_dataModelObjectMutableCopy])
    {
        result = @(index).stringValue;
    }
    return result;
}

-(id)detailsForIndex:(NSUInteger)index
{
    NSString * result = [[_keys[index] class] description];
    return result;
}

-(void)setValue:(id)object atIndex:(NSUInteger)index
{
    if([self isDictionary:_dataModelObjectMutableCopy])
    {
        NSString * name = [self nameForIndex:index];
        [_dataModelObjectMutableCopy setValue:object forKey:name];
    }
    else if([self isArray:_dataModelObjectMutableCopy])
    {
        _dataModelObjectMutableCopy[index] = object;
    }
    else if([self isSet:_dataModelObjectMutableCopy])
    {
        [_dataModelObjectMutableCopy removeObject: [self valueForIndex:index]];
        [_dataModelObjectMutableCopy addObject:object];
    }
}

-(void)deleteValueAtIndex:(NSUInteger)index
{
    if([self isDictionary:_dataModelObjectMutableCopy])
    {
        NSString * key = [self nameForIndex:index];
        NSMutableDictionary * collection = _dataModelObjectMutableCopy;
        [collection removeObjectsForKeys:@[key]];
    }
    else if([self isArray:_dataModelObjectMutableCopy])
    {
        NSMutableArray * collection = _dataModelObjectMutableCopy;
        [collection removeObjectAtIndex:index];
    }
    else if([self isSet:_dataModelObjectMutableCopy])
    {
        NSMutableSet * collection = _dataModelObjectMutableCopy;
        [collection removeObject: [self valueForIndex:index]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FCTableViewCell" forIndexPath:indexPath];
    
    id object = [self valueForIndex:indexPath.row];
    NSString * name = [self nameForIndex:indexPath.row];
    NSString * description = [self detailsForIndex:indexPath.row];

    //configure cell
    [cell.textLabel setText:name];
    [cell.detailTextLabel setText:description];
    
    if( [self isBoolean:object] )
    {
        UISwitch * switchView = [[UISwitch alloc] init];
        [switchView setOn:[object boolValue]];
        [switchView addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
        switchView.translatesAutoresizingMaskIntoConstraints = NO;
        cell.accessoryView = switchView;
    }
    else if([self isCollection:object])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, cell.contentView.frame.size.height)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [textField setDelegate:self];
        cell.accessoryView = textField;
        
        //set value
        if([self isNumber:object] )
        {
            [textField setText:[object stringValue]];
            [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        }
        else if([self isString:object] )
        {
            [textField setText:object];
            [textField setKeyboardType:UIKeyboardTypeASCIICapable];
        }
        
        [textField sizeToFit];
    }
    
    cell.accessoryView.tag = indexPath.row;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self valueForIndex:indexPath.row];
    NSString * name = [self nameForIndex:indexPath.row];
    if([self isCollection:object])
    {
        FCCollectionEditorViewController * tvc = [[FCCollectionEditorViewController alloc] init];
        [tvc setDataModelObject:object];
        tvc.title = name;
        tvc.delegate = self;
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self valueForIndex:indexPath.row];
    return [self isCollection:object];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteValueAtIndex:indexPath.row];
    [self configureData];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark -

-(BOOL)isBoolean:(id)object
{
    NSString * classString = NSStringFromClass([object class]);
    return [classString isEqualToString:@"__NSCFBoolean"];
}

-(BOOL)isNumber:(id)object
{
    NSString * classString = NSStringFromClass([object class]);
    return [classString isEqualToString:@"__NSCFNumber"];
}

-(BOOL)isString:(id)object
{
    NSString * classString = NSStringFromClass([object class]);
    return [object isKindOfClass:[NSString class]] || [classString isEqualToString:@"__NSCFString"];
}

-(BOOL)isDictionary:(id)object
{
    NSString * classString = NSStringFromClass([object class]);
    return [object isKindOfClass:[NSDictionary class]] || [classString isEqualToString:@"__NSCFDictionary"];
}

-(BOOL)isArray:(id)object
{
    NSString * classString = NSStringFromClass([object class]);
    return [object isKindOfClass:[NSArray class]] || [classString isEqualToString:@"__NSCFArray"];
}

-(BOOL)isSet:(id)object
{
    NSString * classString = NSStringFromClass([object class]);
    return [object isKindOfClass:[NSSet class]] || [classString isEqualToString:@"__NSCFSet"];
}

-(BOOL)isCollection:(id)object
{
    return [self isArray:object] || [self isDictionary:object] || [self isSet:object];
}

-(BOOL)isMutableCollection:(id)object
{
    return [object isKindOfClass:[NSMutableArray class]]
    || [object isKindOfClass:[NSMutableDictionary class]]
    || [object isKindOfClass:[NSMutableSet class]]
    || [object isKindOfClass:[NSMutableOrderedSet class]];
}

#pragma mark - Editing

-(void)editHandler:(UIBarButtonItem *)sender
{
    [self.tableView setEditing: !self.tableView.editing animated: YES];
    
    if(!self.tableView.editing)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

-(void)notifyChange
{
    if([self.delegate respondsToSelector:@selector(fcCollectionEditorDidChangeDataModelObject:original:)])
    {
        [self.delegate fcCollectionEditorDidChangeDataModelObject:_dataModelObjectMutableCopy original:_dataModelObjectOriginal];
    }
}

#pragma mark UISwitch delegate

-(void)switchChangeValue:(UISwitch *)sender
{
    [self setValue:@(sender.isOn) atIndex:sender.tag];

    [self notifyChange];
}

#pragma mark text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    id originalObject = [self valueForIndex:textField.tag];
    //set value
    if( [self isNumber:originalObject] )
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * newNumber = [formatter numberFromString:textField.text];

        if(newNumber != nil)
        {
            [self setValue:newNumber atIndex:textField.tag];
        }
        else
        {
            [self showInvalidValueErrorExpected:[[NSNumber class] description]];
            [self.tableView reloadData];
        }
    }
    else if([self isString: originalObject])
    {
        [self setValue:textField.text atIndex:textField.tag];
    }
    
    [textField sizeToFit];
    [self notifyChange];
    
    [self configureData];
    [self.tableView reloadData];
}

#pragma mark - FCCollectionEditorDelegate

-(void)fcCollectionEditorDidChangeDataModelObject:(id)editedObj original:(id)originalObj
{
    if([self isArray:_dataModelObjectMutableCopy])
    {
        NSMutableArray * arrayCollection = _dataModelObjectMutableCopy;
        NSUInteger index = [arrayCollection indexOfObject:originalObj];
        if(index != NSNotFound)
        {
            [arrayCollection replaceObjectAtIndex:index withObject:editedObj];
        }
    }
    else if([self isDictionary:_dataModelObjectMutableCopy])
    {
        NSMutableDictionary * dictionaryCollection = _dataModelObjectMutableCopy;
        NSArray * keysForObj = [dictionaryCollection allKeysForObject:originalObj];
        NSString * key = [keysForObj lastObject];
        if(key != nil)
        {
            [_dataModelObjectMutableCopy setValue:editedObj forKey:key];
        }
    }
    else if([self isSet:_dataModelObjectMutableCopy])
    {
        NSMutableSet * setCollection = _dataModelObjectMutableCopy;
        [setCollection removeObject:originalObj];
        [setCollection addObject:editedObj];
    }
    
    [self notifyChange];
}

#pragma mark - Error management

-(void)showInvalidValueErrorExpected:(NSString *)expectedClassString
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid value", nil)
                               message: [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Expected",nil),expectedClassString]
                              delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                      otherButtonTitles:nil] show];
}

@end
