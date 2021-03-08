#import "FinderPlugin.h"
#if __has_include(<finder/finder-Swift.h>)
#import <finder/finder-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "finder-Swift.h"
#endif

@implementation FinderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFinderPlugin registerWithRegistrar:registrar];
}
@end
