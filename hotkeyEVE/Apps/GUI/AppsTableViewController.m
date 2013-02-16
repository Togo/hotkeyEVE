//
//  AppsUninstalledViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableViewController.h"
#import "AppsManagerAmazon.h"
#import <AppsLibrary/AppsLibrary.h>

NSString * const kAppsTableViewControllerNibName = @"AppsTableViewController";

@interface AppsTableViewController ()

@end

@implementation AppsTableViewController

@synthesize appsManager = _appsManager;

@synthesize moduleIDTableColumn = _moduleIDTableColumn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.appsManager = [[AppsManagerAmazon alloc] init];
      self.progressIndicator = [self createProgressIndicator];
    }
  
    return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) awakeFromNib {
  [_moduleIDTableColumn setIdentifier:kModuleID];
  [_moduleIDTableColumn setHidden:YES];
  
  [_appNameTableColumn setIdentifier:kAppNameKey];
  [_appNameTableColumn setEditable:NO];
  [_appNameTableColumn setSortDescriptorPrototype:[[NSSortDescriptor alloc] initWithKey:kAppNameKey ascending:NO]];
  
  [_languageTableColumn setIdentifier:kLanguageKey];
  [_languageTableColumn setEditable:NO];
  [_languageTableColumn setSortDescriptorPrototype:[[NSSortDescriptor alloc] initWithKey:kLanguageKey ascending:NO]];

  [_userNameTableColumn setIdentifier:kUserNameKey];
  [_userNameTableColumn setEditable:NO];
  [_userNameTableColumn setSortDescriptorPrototype:[[NSSortDescriptor alloc] initWithKey:kUserNameKey ascending:NO]];
  
  [_credatTableColumn setIdentifier:kModuleCredatKey];
  [_credatTableColumn setEditable:NO];
  [_credatTableColumn setSortDescriptorPrototype:[[NSSortDescriptor alloc] initWithKey:kModuleCredatKey ascending:NO]];
  
  [_tableView registerForDraggedTypes:[NSArray arrayWithObjects: NSPasteboardTypeString , nil]];
  
  [self registerObserver];
}

- (void) registerObserver {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeRowsFromTable) name:kEVENotificationsRemoveDropedLinesFromTable object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTableData) name:kEVENotificationsReloadAppsTable object:nil];
}

- (NSProgressIndicator*) createProgressIndicator {
  NSProgressIndicator *progressIndicator = [[NSProgressIndicator alloc] init];
  [progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
  
  return progressIndicator;
}

- (void) loadView {
  [super loadView];

  [self loadTableData];
}


- (void) loadTableData {
    NSLog(@"Reload table data");
  [self startProgressAnimationinSuperview:_tableView];
  dispatch_async(dispatch_get_global_queue(0,0),^{
    _dataSource = [_appsManager loadTableSourceData];
    [_tableView reloadData];
    [self stopProgressAnimation];
  });
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [_dataSource count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  id returnParameter;
  if ([tableColumn identifier] == kModuleCredatKey) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    NSString *unformattedString =  [[_dataSource objectAtIndex:row] valueForKey:[tableColumn identifier]];
    NSDate *date = [NSDate dateWithNaturalLanguageString:unformattedString];
    
    returnParameter = [dateFormatter stringFromDate:date];
  } else
    returnParameter = [[_dataSource objectAtIndex:row] valueForKey:[tableColumn identifier]];
  
  
  return returnParameter;
}

-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange: (NSArray *)oldDescriptors
{
  NSArray *newDescriptors = [tableView sortDescriptors];
  [_dataSource sortUsingDescriptors:newDescriptors];
  [tableView reloadData];
}

- (void) startProgressAnimationinSuperview :(NSView*) superview {
    if ( superview != nil ) {
    [_progressIndicator setFrame:[superview bounds]];
 
    [_progressIndicator startAnimation:nil];
    [superview addSubview:_progressIndicator];
  } else
      @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                            reason:@"Can't start a Animation in a nil Superview" userInfo:nil];
}

- (void) stopProgressAnimation {
    [_progressIndicator stopAnimation:nil];
    [_progressIndicator removeFromSuperview];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
  // Drag and drop support
  if ([rowIndexes count] > 0) {
    NSMutableArray *pasteBoardStringArray = [NSMutableArray array];
    NSInteger currentIndex = [rowIndexes firstIndex];
    while (currentIndex != NSNotFound) {
      NSString *moduleID = [[_dataSource objectAtIndex:currentIndex] valueForKey:kModuleID];
      [pasteBoardStringArray addObject:moduleID];
    
      currentIndex = [rowIndexes indexGreaterThanIndex: currentIndex];
    }
    
    [pboard setString:[pasteBoardStringArray componentsJoinedByString:@"\n"] forType:NSPasteboardTypeString];
    
    return YES;
  } else {
     return NO;
  }
}

- (void) removeRowsFromTable {
//  [_tableView beginUpdates];
//  [_tableView removeRowsAtIndexes:[_tableView selectedRowIndexes] withAnimation:NSTableViewAnimationEffectNone];
//  [_tableView endUpdates];
}

@end
