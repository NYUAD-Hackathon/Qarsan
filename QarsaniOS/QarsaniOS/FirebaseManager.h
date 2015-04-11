//
//  FirebaseManager.h
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#ifndef FIREBASEMANAGER_H
#define FIREBASEMANAGER_H

#import <Foundation/Foundation.h>

@protocol FirebaseManagerDelegate
  -(void) didFetchStories;
@end

@interface FirebaseManager : NSObject

+ (id)sharedManager;

- (void)setDelegate : (id<FirebaseManagerDelegate>) delegate;

- (int)getNumberOfStories;

- (void)fetchAllHeadlines;

-(NSString *)getHeadlineWithId:(NSNumber *)_id;

-(NSString *) getStoryWithId:(NSNumber *) _id;

-(NSString *)getCategoryWithId:(NSNumber *)_id;

- (int)getNumberOfStoriesForCategory:(NSString *)sectionTitle;

- (int)getIndexForSection:(int)section andRow:(int)row;

@end

#endif