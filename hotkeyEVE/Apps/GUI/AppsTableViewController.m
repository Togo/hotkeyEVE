//
//  AppsUninstalledViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableViewController.h"
#import "TGEVE_AppsManagerAmazon.h"
#import <AppsLibrary/AppsLibrary.h>
#import "AppModuleTableModel.h"

NSString * const kAppsTableViewControllerNibName = @"AppsTableViewController";

@interface AppsTableViewController ()

@end

@implementation AppsTableViewController

@synthesize appsManager = _appsManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.appsManager = [[TGEVE_AppsManagerAmazon alloc] init];
    }
  
    return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) awakeFromNib {
  [_installedTableColumn setIdentifier:TGUTIL_TCOLID_INSTALLED];
  [_installedTableColumn setEditable:YES];
  
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
  [self startProgressAnimationinSuperview:_tableView];
  dispatch_async(dispatch_get_main_queue(),^{
    _dataSource = [_appsManager loadTableDataFromDB];
    for (NSDictionary *aRow in _dataSource ) {
      BOOL appModuleInstalled = [_appsManager isAppInstalled:[aRow valueForKey:kModuleID]];
      [aRow setValue:[NSString stringWithFormat:@"%d", appModuleInstalled] forKey:TGUTIL_TCOLID_INSTALLED];
    }
    [self stopProgressAnimation];
    [_tableView reloadData];
  });
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [_dataSource count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  id returnParameter;
  if ( [tableColumn identifier] == kModuleCredatKey ) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    NSString *unformattedString =  [[_dataSource objectAtIndex:row] valueForKey:[tableColumn identifier]];
    NSDate *date = [NSDate dateWithNaturalLanguageString:unformattedString];
    
    returnParameter = [dateFormatter stringFromDate:date];
  } else
    returnParameter = [[_dataSource objectAtIndex:row] valueForKey:[tableColumn identifier]];
  
  return returnParameter;
}
            
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  if ( [[aTableColumn identifier] isEqualToString:TGUTIL_TCOLID_INSTALLED] ) {
    BOOL succeded = YES;
    NSString *moduleID = [[_dataSource objectAtIndex:rowIndex] valueForKey:kModuleID];
    if ( [anObject intValue] == NSOnState ) {
        succeded = [_appsManager addAppWithModuleID:moduleID];
    } else {
      [_appsManager removeAppWithModuleID:moduleID];
    }
    
    if( succeded )
      [[_dataSource objectAtIndex:rowIndex] setObject :anObject forKey :[aTableColumn identifier]];
  }
}


-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange: (NSArray *)oldDescriptors
{
  NSArray *newDescriptors = [tableView sortDescriptors];
  [_dataSource sortUsingDescriptors:newDescriptors];
  [tableView reloadData];
}

- (void) startProgressAnimationinSuperview :(NSView*) superview {
  if(_progressIndicator != nil) {
    [self stopProgressAnimation];
  }
  
  if ( superview != nil ) {
  _progressIndicator = [self createProgressIndicator];
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
    _progressIndicator = nil;
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
    NSIndexSet *rowIndexes = [_tableView selectedRowIndexes];
    NSUInteger selectedIndex;
    if ( [rowIndexes lastIndex] != NSNotFound )
      selectedIndex = [rowIndexes lastIndex];
    else
      selectedIndex = 0;

    [_tableView beginUpdates];
    [_tableView removeRowsAtIndexes:rowIndexes withAnimation:NSTableViewAnimationEffectFade];
    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedIndex] byExtendingSelection:NO];
    [_dataSource removeObjectsAtIndexes:rowIndexes];
    [_tableView endUpdates];
}

@end
