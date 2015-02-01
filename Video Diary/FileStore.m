//
//  FileStore.m
//  Video Diary
//
//  Created by Andrew Bell on 1/29/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "FileStore.h"

@interface FileStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation FileStore

+ (instancetype)sharedStore
{
    static FileStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use + [FileStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setVideoURL:(NSURL *)url forKey:(NSString *)key
{
    self.dictionary[key] = url;
}

- (NSURL *)videoURLForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteFileForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
    
    NSString *filePath = [self filePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (NSString *)filePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentDirectories firstObject];
    NSString *pathString = [NSString stringWithFormat:@"/%@.mov", key];
    NSString *newPath = [documentsDirectory stringByAppendingFormat:pathString];
    
    return newPath;
}



@end
