#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface ImageMetadataHandler : NSObject<FlutterPlugin>

- (NSData *)addMetadata:(NSData *)imageData metadata:(NSDictionary *)metadata;

@end 