//
//  EVEUtilities.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "EVEUtilities.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation EVEUtilities

+ (Application*) activeApplication {
  NSDictionary *appDic = [[NSWorkspace sharedWorkspace] activeApplication];
  NSString *bundleIdentifier = [appDic valueForKey:@"NSApplicationBundleIdentifier"];
  
  return [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
}

+ (NSString*) currentLanguage {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
  NSString *currentLanguage = [languages objectAtIndex:0];
  return currentLanguage;
}

+ (NSString*) getMacAddress {
  int                 mgmtInfoBase[6];
  char                *msgBuffer = NULL;
  size_t              length;
  unsigned char       macAddress[6];
  struct if_msghdr    *interfaceMsgStruct;
  struct sockaddr_dl  *socketStruct;
  NSString            *errorFlag = NULL;
  
  // Setup the management Information Base (mib)
  mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
  mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
  mgmtInfoBase[2] = 0;
  mgmtInfoBase[3] = AF_LINK;        // Request link layer information
  mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
  
  // With all configured interfaces requested, get handle index
  if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
    errorFlag = @"if_nametoindex failure";
  else
  {
    // Get the size of the data available (store in len)
    if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
      errorFlag = @"sysctl mgmtInfoBase failure";
    else
    {
      // Alloc memory based on above call
      if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
      else
      {
        // Get system information, store in buffer
        if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
          errorFlag = @"sysctl msgBuffer failure";
      }
    }
  }
  
  // Befor going any further...
  if (errorFlag != NULL)
  {
    DDLogError(@"Error: %@", errorFlag);
    return errorFlag;
  }
  
  // Map msgbuffer to interface message structure
  interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
  
  // Map to link-level socket structure
  socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
  
  // Copy link layer address data in socket structure to an array
  memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
  
  // Read from char array into a string object, into traditional Mac address format
  NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                macAddress[0], macAddress[1], macAddress[2],
                                macAddress[3], macAddress[4], macAddress[5]];
  // Release the buffer memory
  free(msgBuffer);
  
  return macAddressString;
}

+ (void) restartEVE {
  //$N = argv[N]
  NSString *killArg1AndOpenArg2Script = @"kill -9 $1 \n open \"$2\"";
  
  //NSTask needs its arguments to be strings
  NSString *ourPID = [NSString stringWithFormat:@"%d",
                      [[NSProcessInfo processInfo] processIdentifier]];
  
  //this will be the path to the .app bundle,
  //not the executable inside it; exactly what `open` wants
  NSString * pathToUs = [[NSBundle mainBundle] bundlePath];
  
  NSArray *shArgs = [NSArray arrayWithObjects:@"-c", // -c tells sh to execute the next argument, passing it the remaining arguments.
                     killArg1AndOpenArg2Script,
                     @"", //$0 path to script (ignored)
                     ourPID, //$1 in restartScript
                     pathToUs, //$2 in the restartScript
                     nil];
  NSTask *restartTask = [NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:shArgs];
  [restartTask waitUntilExit]; //wait for killArg1AndOpenArg2Script to finish
  NSLog(@"*** ERROR: %@ should have been terminated, but we are still running", pathToUs);
  assert(!"We should not be running!");
}

+ (void) addAppToLoginItems {
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
  
	// This will retrieve the path for the application
	// For example, /Applications/test.app
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
  
	// Create a reference to the shared file list.
  // We are adding it to the current user only.
  // If we want to add it all users, use
  // kLSSharedFileListGlobalLoginItems instead of
  //kLSSharedFileListSessionLoginItems
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                          kLSSharedFileListSessionLoginItems, NULL);
	if (loginItems) {
		//Insert an item to the list.
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                 kLSSharedFileListItemLast, NULL, NULL,
                                                                 url, NULL, NULL);
		if (item){
			CFRelease(item);
    }
    
  CFRelease(loginItems);
	}
}

+ (void) removeAppFromLoginItems {
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
  
	// This will retrieve the path for the application
	// For example, /Applications/test.app
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
  
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                          kLSSharedFileListSessionLoginItems, NULL);
  
	if (loginItems) {
		UInt32 seedValue;
		//Retrieve the list of Login Items and cast them to
		// a NSArray so that it will be easier to iterate.
		NSArray  *loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
		for(int i = 0 ; i< [loginItemsArray count]; i++) {
			LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray
                                                                           objectAtIndex:i];
			//Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(__bridge NSURL*)url path];
				if ([urlPath compare:appPath] == NSOrderedSame){
					LSSharedFileListItemRemove(loginItems,itemRef);
				}
			}
		}
	}
}

+ (void) openWebShop {
  NSURL *url = [NSURL URLWithString:  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"Shop URL"]];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

+ (void) checkAccessibilityAPIEnabled {
  // We first have to check if the Accessibility APIs are turned on.  If not, we have to tell the user to do it (they'll need to authenticate to do it).  If you are an accessibility app (i.e., if you are getting info about UI elements in other apps), the APIs won't work unless the APIs are turned on.
  if (!AXAPIEnabled()) {
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setMessageText:@"EVE requires that the Accessibility API be enabled."];
    [alert setInformativeText:@"Would you like to launch System Preferences so that you can turn on \"Enable access for assistive devices\"?"];
    [alert addButtonWithTitle:@"Open System Preferences"];
    [alert addButtonWithTitle:@"Continue Anyway"];
    [alert addButtonWithTitle:@"Quit UI"];
    
    NSInteger alertResult = [alert runModal];
    
    switch (alertResult) {
      case NSAlertFirstButtonReturn: {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSSystemDomainMask, YES);
        if ([paths count] == 1) {
          NSURL *prefPaneURL = [NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"UniversalAccessPref.prefPane"]];
          [[NSWorkspace sharedWorkspace] openURL:prefPaneURL];
        }
      }
        break;
        
      case NSAlertSecondButtonReturn: // just continue
      default:
        break;
        
      case NSAlertThirdButtonReturn:
        [NSApp terminate:self];
        return;
        break;
    }
  } else {
    DDLogInfo(@"Accessibility API is enabled");
  }
}


@end
