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
}

- (NSString *)filePathForKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *newPath = [NSString stringWithFormat:@"/%@.mov", key];
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:newPath];
    
    return tempPath;
}



@end
