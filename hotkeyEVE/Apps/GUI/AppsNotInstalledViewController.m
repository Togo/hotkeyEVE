//
//  AppsUninstalledViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsNotInstalledViewController.h"
#import "AppsAmazonModel.h"

NSString * const kAppsNotInstalledViewControllerNibName = @"AppsNotInstalledViewController";

@interface AppsNotInstalledViewController ()

@end

@implementation AppsNotInstalledViewController

@synthesize model = _model;

@synthesize moduleIDTableColumn = _moduleIDTableColumn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.model = [[AppsAmazonModel alloc] init];
      self.progressIndicator = [self createProgressIndicitor];
    }
  
    return self;
}

-(void) awakeFromNib {
  [_moduleIDTableColumn setIdentifier:kModuleID];
  [_appNameTableColumn setIdentifier:kAppNameKey];
  [_languageTableColumn setIdentifier:kLanguageKey];
  [_userNameTableColumn setIdentifier:kUserNameKey];
  [_credatTableColumn setIdentifier:kModuleCredatKey];
}

- (NSProgressIndicator*) createProgressIndicitor {
  NSProgressIndicator *progressIndicator = [[NSProgressIndicator alloc] init];
//  [progressIndicator setIndeterminate:YES];
  [progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
////  [self.progressIndicator setControlSize:NSRegularControlSize];
////  [self.progressIndicator setMinValue:0];
////  [self.progressIndicator setMaxValue:100];
////  [self.progressIndicator setDoubleValue:25];
  
  return progressIndicator;
}

- (void) loadView {
  [super loadView];
  [self performSelectorInBackground:@selector(loadTableData) withObject:nil];
}

- (void) loadTableData {
  [self startProgressAnimationinSuperview:_tableView];
  
  _dataSource = [_model getNotInstalledList];
  [_tableView reloadData];
  
  [self stopProgressAnimation];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [_dataSource count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[_dataSource objectAtIndex:row] valueForKey:[tableColumn identifier]];
}

-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange: (NSArray *)oldDescriptors
{
  NSArray *newDescriptors = [tableView sortDescriptors];
  [_dataSource sortUsingDescriptors:newDescriptors];
  [tableView reloadData];
}

- (void) startProgressAnimationinSuperview :(NSView*) superview {
  if ( !(superview == nil) ) {
    [superview addSubview:_progressIndicator];
    
    [_progressIndicator setFrame:[superview frame]];
    [_progressIndicator startAnimation:nil];
  } else
      @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                            reason:@"Can't start a Animation in a nil Superview" userInfo:nil];
}

- (void) stopProgressAnimation {
    [_progressIndicator stopAnimation:nil];
    [_progressIndicator removeFromSuperview];
}

@end
