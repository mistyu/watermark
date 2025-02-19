#import "ImageMetadataHandler.h"
#import <ImageIO/ImageIO.h>

// 定义 TIFF 和 EXIF 相关常量
#define kCGImagePropertyTIFFDictionary CFSTR("{TIFF}")
#define kCGImagePropertyTIFFArtist CFSTR("Artist")
#define kCGImagePropertyTIFFCopyright CFSTR("Copyright")
#define kCGImagePropertyTIFFSoftware CFSTR("Software")
#define kCGImagePropertyTIFFDateTime CFSTR("DateTime")
#define kCGImagePropertyTIFFImageWidth CFSTR("ImageWidth")
#define kCGImagePropertyTIFFImageLength CFSTR("ImageLength")
#define kCGImagePropertyExifDictionary CFSTR("{Exif}")
#define kCGImagePropertyExifUserComment CFSTR("UserComment")

@interface ImageMetadataHandler()
@end

@implementation ImageMetadataHandler

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"image_metadata_handler"
        binaryMessenger:[registrar messenger]];
    ImageMetadataHandler* instance = [[ImageMetadataHandler alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"addMetadata" isEqualToString:call.method]) {
        NSDictionary* args = call.arguments;
        FlutterStandardTypedData* imageData = args[@"imageData"];
        NSDictionary* metadata = args[@"metadata"];
        
        NSData* processedData = [self addMetadata:imageData.data metadata:metadata];
        if (processedData) {
            result([FlutterStandardTypedData typedDataWithBytes:processedData]);
        } else {
            result([FlutterError errorWithCode:@"PROCESS_ERROR"
                                    message:@"Failed to process image metadata"
                                    details:nil]);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSData *)addMetadata:(NSData *)imageData metadata:(NSDictionary *)metadata {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!source) {
        return nil;
    }
    
    CFStringRef type = CGImageSourceGetType(source);
    if (!type) {
        CFRelease(source);
        return nil;
    }
    
    NSMutableData *destination = [NSMutableData data];
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData(
        (__bridge CFMutableDataRef)destination,
        type,
        1,
        NULL
    );
    
    if (!imageDestination) {
        CFRelease(source);
        return nil;
    }
    
    NSMutableDictionary *metadataDict = [NSMutableDictionary dictionary];
    
    // TIFF Dictionary
    NSMutableDictionary *tiffDict = [NSMutableDictionary dictionary];
    if (metadata[@"artist"]) {
        tiffDict[(NSString *)kCGImagePropertyTIFFArtist] = metadata[@"artist"];
    }
    if (metadata[@"copyright"]) {
        tiffDict[(NSString *)kCGImagePropertyTIFFCopyright] = metadata[@"copyright"];
    }
    if (metadata[@"software"]) {
        tiffDict[(NSString *)kCGImagePropertyTIFFSoftware] = metadata[@"software"];
    }
    if (metadata[@"datetime"]) {
        tiffDict[(NSString *)kCGImagePropertyTIFFDateTime] = metadata[@"datetime"];
    }
    if (metadata[@"width"]) {
        tiffDict[(NSString *)kCGImagePropertyTIFFImageWidth] = metadata[@"width"];
    }
    if (metadata[@"height"]) {
        tiffDict[(NSString *)kCGImagePropertyTIFFImageLength] = metadata[@"height"];
    }
    
    if (tiffDict.count > 0) {
        metadataDict[(NSString *)kCGImagePropertyTIFFDictionary] = tiffDict;
    }
    
    // EXIF Dictionary
    NSMutableDictionary *exifDict = [NSMutableDictionary dictionary];
    
    // Custom metadata as user comments
    NSMutableArray *customComments = [NSMutableArray array];
    [metadata enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        if (![@[@"artist", @"copyright", @"software", @"datetime"] containsObject:key]) {
            [customComments addObject:[NSString stringWithFormat:@"%@: %@", key, value]];
        }
    }];
    
    if (customComments.count > 0) {
        exifDict[(NSString *)kCGImagePropertyExifUserComment] = [customComments componentsJoinedByString:@"\n"];
    }
    
    if (exifDict.count > 0) {
        metadataDict[(NSString *)kCGImagePropertyExifDictionary] = exifDict;
    }
    
    CGImageDestinationAddImageFromSource(
        imageDestination,
        source,
        0,
        (__bridge CFDictionaryRef)metadataDict
    );
    
    BOOL success = CGImageDestinationFinalize(imageDestination);
    
    CFRelease(source);
    CFRelease(imageDestination);
    
    return success ? destination : nil;
}

@end 