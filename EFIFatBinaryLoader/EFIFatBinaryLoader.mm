#import <Foundation/Foundation.h>
#import <Hopper/Hopper.h>
#import "EFIFatBinary.hpp"
#import "HPHopperServicesPatched.h"

@interface EFIFatBinaryLoader : NSObject<FileLoader>

@end

@implementation EFIFatBinaryLoader {
    NSObject<HPHopperServices, HPHopperServicesPatched> *_services;
}

#pragma mark - HopperPlugin

- (instancetype)initWithHopperServices:(NSObject <HPHopperServices> *)services {
    self = [super init];
    if (self) {
        _services = (NSObject <HPHopperServices, HPHopperServicesPatched> *)services;
    }
    return self;
}

- (HopperUUID *)pluginUUID {
    return [_services UUIDWithString:@"84536313-2D84-4E5B-9A46-3E45B7BA48CC"];
}

- (HopperPluginType)pluginType {
    return Plugin_Loader;
}

- (NSString *)pluginName {
    return @"EFIFATLoader";
}

- (NSString *)pluginDescription {
    return @"EFI FAT Binary Loader";
}

- (NSString *)pluginAuthor {
    return @"Ievgen Solodovnykov";
}

- (NSString *)pluginCopyright {
    return @"©2015 – Ievgen Solodovnykov";
}

- (NSString *)pluginVersion {
    return @"1.0.0";
}

#pragma mark - FileLoader

- (BOOL)canLoadDebugFiles {
    return NO;
}

- (NSArray *)detectedTypesForData:(NSData *)data {
    if ([data length] < 4) return @[];

    const void *bytes = [data bytes];
    if (OSReadLittleInt32(bytes, 0) == EFI_FAT_BINARY_MAGIC) {
        NSObject<HPDetectedFileType> *type = [_services detectedType];
        [type setFileDescription:@"EFI Fat Binary"];
        [type setShortDescriptionString:@"efi_fat_binary"];
        [type setCompositeFile:YES];

        uint32_t count = OSReadLittleInt32(bytes, 4);
        NSMutableArray *optionsList = [NSMutableArray array];
        for (uint32_t index = 0; index < count; index++) {
            EFIFatEmbeddedFile file(bytes, index);
            [optionsList addObject:@(file.description())];
        }

        NSObject<HPLoaderOptionComponents> *options;
        options = [_services stringListComponentWithLabel:@"File" andList:optionsList];
        [type setAdditionalParameters:@[options]];

        return @[type];
    }

    return @[];
}

- (FileLoaderLoadingStatus)loadData:(NSData *)data usingDetectedFileType:(DetectedFileType *)fileType options:(FileLoaderOptions)options forFile:(NSObject <HPDisassembledFile> *)file usingCallback:(FileLoadingCallbackInfo)callback {
    return DIS_NotSupported;
}

- (FileLoaderLoadingStatus)loadDebugData:(NSData *)data forFile:(NSObject <HPDisassembledFile> *)file usingCallback:(FileLoadingCallbackInfo)callback {
    return DIS_NotSupported;
}

- (void)fixupRebasedFile:(NSObject <HPDisassembledFile> *)file withSlide:(int64_t)slide originalFileData:(NSData *)fileData {}

- (NSData *)extractFromData:(NSData *)data usingDetectedFileType:(NSObject <HPDetectedFileType> *)fileType returnAdjustOffset:(uint64_t *)adjustOffset {
    uint32_t index = (uint32_t)[(NSObject<HPLoaderOptionComponents> *)(fileType.additionalParameters)[0] selectedStringIndex];
    EFIFatEmbeddedFile file(data.bytes, index);
    NSRange range{file.offset, file.length};
    return [data subdataWithRange:range];
}

@end
