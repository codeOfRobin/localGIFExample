//
//  ASBatchFetching.m
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "ASBatchFetching.h"

BOOL ASDisplayShouldFetchBatchForScrollView(UIScrollView<ASBatchFetchingScrollView> *scrollView, ASScrollDirection scrollDirection, ASScrollDirection scrollableDirections, CGPoint contentOffset)
{
  // Don't fetch if the scroll view does not allow
  if (![scrollView canBatchFetch]) {
    return NO;
  }
  
  // Check if we should batch fetch
  ASBatchContext *context = scrollView.batchContext;
  CGRect bounds = scrollView.bounds;
  CGSize contentSize = scrollView.contentSize;
  CGFloat leadingScreens = scrollView.leadingScreensForBatching;
  return ASDisplayShouldFetchBatchForContext(context, scrollDirection, scrollableDirections, bounds, contentSize, contentOffset, leadingScreens);
}

BOOL ASDisplayShouldFetchBatchForContext(ASBatchContext *context,
                                         ASScrollDirection scrollDirection,
                                         ASScrollDirection scrollableDirections,
                                         CGRect bounds,
                                         CGSize contentSize,
                                         CGPoint targetOffset,
                                         CGFloat leadingScreens)
{
  // Do not allow fetching if a batch is already in-flight and hasn't been completed or cancelled
  if ([context isFetching]) {
    return NO;
  }

  // No fetching for null states
  if (leadingScreens <= 0.0 || CGRectIsEmpty(bounds)) {
    return NO;
  }

  CGFloat viewLength, offset, contentLength;

  if (ASScrollDirectionContainsVerticalDirection(scrollableDirections)) {
    viewLength = bounds.size.height;
    offset = targetOffset.y;
    contentLength = contentSize.height;
  } else { // horizontal / right
    viewLength = bounds.size.width;
    offset = targetOffset.x;
    contentLength = contentSize.width;
  }

  // target offset will always be 0 if the content size is smaller than the viewport
  BOOL hasSmallContent = offset == 0.0 && contentLength < viewLength;
  if (hasSmallContent) {
    return YES;
  }

  BOOL isScrollingTowardEnd = (ASScrollDirectionContainsDown(scrollDirection) || ASScrollDirectionContainsRight(scrollDirection));

  CGFloat triggerDistance = viewLength * leadingScreens;
  CGFloat remainingDistance = contentLength - viewLength - offset;

  return isScrollingTowardEnd && remainingDistance <= triggerDistance;
}
