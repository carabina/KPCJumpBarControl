//
//  NSIndexPath+KPCUtils.m
//  KPCJumpBarControl
//
//  Created by Cédric Foellmi on 01/05/16.
//  Licensed under the MIT License (see LICENSE file)
//

#import "NSIndexPath+KPCUtils.h"

@implementation NSIndexPath (KPCUtils)

- (NSInteger)KPC_lastIndex
{
    return [self indexAtPosition:[self length]-1];
}

- (NSIndexPath *)KPC_indexPathByAddingIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [self copy];
    for (NSUInteger position = 0; position < indexPath.length ; position ++) {
        path = [path indexPathByAddingIndex:[indexPath indexAtPosition:position]];
    }
    return path;
}

- (NSIndexPath *)KPC_indexPathByAddingIndexInFront:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
    return [indexPath KPC_indexPathByAddingIndexPath:self];
}

- (NSIndexPath *)KPC_subIndexPathFromPosition:(NSUInteger)position
{
    return [self KPC_subIndexPathWithRange:NSMakeRange(position, self.length-1 - position)];
}

- (NSIndexPath *)KPC_subIndexPathToPosition:(NSUInteger)position
{
    return [self KPC_subIndexPathWithRange:NSMakeRange(0, position)];
}

- (NSIndexPath *)KPC_subIndexPathWithRange:(NSRange)range
{
    if (range.location + range.length == self.length || range.location >= self.length) {
        return [[NSIndexPath alloc] init];
    }
    
    NSIndexPath *path = [[NSIndexPath alloc] init];
    NSUInteger end = MIN(range.location + range.length, self.length-1);
    for (NSUInteger position = range.location; position <= end ; position ++) {
        path = [path indexPathByAddingIndex:[self indexAtPosition:position]];
    }
    
    return path;
}

- (NSIndexPath *)KPC_indexPathByReplacingIndexAtPosition:(NSUInteger)position withIndex:(NSInteger)index
{
    if (position == 0) {
        NSIndexPath *trailIndexPath = [self KPC_subIndexPathFromPosition:position+1];
        return [[NSIndexPath indexPathWithIndex:index] KPC_indexPathByAddingIndexPath:trailIndexPath];
    }
    else if (position == [self length]-1) {
        NSIndexPath *frontIndexPath = [self KPC_subIndexPathToPosition:position];
        return [frontIndexPath indexPathByAddingIndex:index];
    }
    else {
        NSIndexPath *frontIndexPath = [self KPC_subIndexPathToPosition:position];
        NSIndexPath *trailIndexPath = [self KPC_subIndexPathFromPosition:position+1];
        return [[frontIndexPath indexPathByAddingIndex:index] KPC_indexPathByAddingIndexPath:trailIndexPath];
    }
}

- (NSIndexPath *)KPC_indexPathByReplacingLastIndexWithIndex:(NSInteger)index
{
    return [self KPC_indexPathByReplacingIndexAtPosition:[self length]-1 withIndex:index];
}

- (NSIndexPath *)KPC_indexPathByIncrementingLastIndex
{
    NSInteger lastIndex = [self indexAtPosition:[self length]-1];
    return [self KPC_indexPathByReplacingIndexAtPosition:[self length]-1 withIndex:lastIndex+1];
}

- (NSIndexPath *)KPC_indexPathByFillingWithIndexPath:(NSIndexPath *)complementIndexPath
{
    NSAssert([self length] <= [complementIndexPath length], @"Index length is wrong.");
    NSIndexPath *cutIndexPath = [complementIndexPath KPC_subIndexPathToPosition:[self length]];
    return [self KPC_indexPathByAddingIndexPath:cutIndexPath];
}

@end
