#import "EventAppDelegate.h"
#import "RootViewController.h"

@implementation EventAppDelegate

@synthesize window, navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)awakeFromNib {  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
  
    return YES;
}

#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end

