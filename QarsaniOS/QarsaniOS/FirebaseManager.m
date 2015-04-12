//
//  FirebaseManager.m
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#import "FirebaseManager.h"
#import <Firebase/Firebase.h>

@implementation FirebaseManager
{
  Firebase * myRootRef;
  int _numStories;
  NSMutableDictionary *_storyMap;
  NSMutableDictionary *_headlineMap;
  NSMutableDictionary *_categoryMap;
  NSMutableDictionary *_categoryNums;
  id<FirebaseManagerDelegate> _delegate;
}

#pragma mark Singleton Methods

+ (id)sharedManager {
  static FirebaseManager *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (id)init {
  if (self = [super init]) {
    // Create a reference to a Firebase location
    myRootRef = [[Firebase alloc] initWithUrl:@"https://brilliant-torch-1595.firebaseio.com/"];
    
    _numStories = -1;
    
    _headlineMap = [NSMutableDictionary dictionary];
    _storyMap = [NSMutableDictionary dictionary];
    _categoryMap = [NSMutableDictionary dictionary];
    
    _categoryNums = [NSMutableDictionary dictionary];
    
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

-(int) getNumberOfStories
{
  if (_numStories == -1)
  {

    /*[[myRootRef queryOrderedByChild:@"numArticles" ]
     observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
       _numStories = [(NSString *)snapshot.value characterAtIndex:0] - '0';
       [self fetchAllHeadlines];
     }];*/
    
    // Create a reference to a Firebase location
    myRootRef = [[Firebase alloc] initWithUrl:@"https://brilliant-torch-1595.firebaseio.com/"];
    
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
      NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
      NSDictionary * keys = (NSDictionary *)snapshot.value;
      
      [_categoryNums removeAllObjects];
      
      //NSArray * arrayValue = [keys componentsSeparatedByString:@"\; "];
      _numStories = [(NSNumber *)[keys objectForKey:@"numArticles"] intValue];
      
      for (int i = 0; i < _numStories; i++)
      {
        NSString * headlineString = [NSString stringWithFormat:@"%iHeadline", i];
        NSNumber * currNumber = [NSNumber numberWithInt:i];
        _headlineMap[currNumber] = [keys objectForKey:headlineString];
        
        
        NSString * articleString = [NSString stringWithFormat:@"%iArticle", i];
        _storyMap[currNumber] = [keys objectForKey:articleString];
        
        NSString * categoryString = [NSString stringWithFormat:@"%iCategory", i];
        _categoryMap[currNumber] = [keys objectForKey:categoryString];
        
        NSNumber * currNum = _categoryNums[[keys objectForKey:categoryString]];
        
        int currNumInt = 0;
        if (currNum)
        {
          currNumInt = [currNum intValue];
        }
        _categoryNums[[keys objectForKey:categoryString]] = [NSNumber numberWithInt:currNumInt+1];
      }
      
      [_delegate didFetchStories];
      
      
    }];
    //myRootRef setV
    
    //Firebase *testingRef = [myRootRef childByAppendingPath: @"TESTING"];
    //[alanRef setValue: alanisawesome];
    //[testingRef setValue:@"TESTING"];
    return 0;
  } else {
    return _numStories;
  }
}

- (int)getIndexForSection:(int)section andRow:(int)row
{
  int cellIndex = 0;
  int numFound = 0;
  NSString * sectionString;
  if (section == 0)
  {
    sectionString = @"Women";
  } else if (section == 1) {
    sectionString = @"World";
  } else {
    sectionString = @"Middle East";
  }
  while(!(numFound > row))
  {
    if ([sectionString isEqualToString: [self getCategoryWithId:[NSNumber numberWithInt:cellIndex]]])
    {
      numFound++;
    }
    cellIndex++;
  }
  return cellIndex - 1;
}

-(void) fetchAllHeadlines
{
  for (int i = 0; i < _numStories; i++)
  {
    
    NSString * headlineString = [NSString stringWithFormat:@"%iHeadline", i];
    [[myRootRef queryOrderedByChild:headlineString ]
     observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
       NSString * keyString = (NSString *)snapshot.key;
       int key = [keyString characterAtIndex:0] - '0';
       NSNumber * currNumber = [NSNumber numberWithInt:key];

      _headlineMap[currNumber] = snapshot.value;
     }];
    
    
    NSString * articleString = [NSString stringWithFormat:@"%iArticle", i];
    [[myRootRef queryOrderedByChild:articleString ]
     observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
       NSString * keyString = (NSString *)snapshot.key;
       int key = [keyString characterAtIndex:0] - '0';
       NSNumber * currNumber = [NSNumber numberWithInt:key];
       
       _storyMap[currNumber] = snapshot.value;
     }];
  }
}

-(NSString *)getHeadlineWithId:(NSNumber *)_id
{
  if ([_headlineMap objectForKey:_id]== nil)
  {
    return @"Loading story";
  } else {
    return [_headlineMap objectForKey:_id];
  }
}

-(NSString *) getStoryWithId:(NSNumber *) _id
{
  if ([_storyMap objectForKey:_id]== nil)
  {
    return @"Loading story";
  } else {
    return [_storyMap objectForKey:_id];
  }
}

-(NSString *)getCategoryWithId:(NSNumber *)_id
{
  if ([_categoryMap objectForKey:_id]== nil)
  {
    assert(0);
    return @"Loading story";
  } else {
    return [_categoryMap objectForKey:_id];
  }
}

- (void)setDelegate: (id<FirebaseManagerDelegate>) delegate
{
  _delegate = delegate;
}

- (int)getNumberOfStoriesForCategory:(NSString *)sectionTitle
{
  return [_categoryNums[sectionTitle] intValue];
}

- (void)saveArticle:(NSString *)category headline: (NSString *)headline article: (NSString *)article
{
  //Get the number of articles currently
  NSString * prependString = [NSString stringWithFormat:@"%i", _numStories];
  NSString * categoryString = [prependString stringByAppendingString:@"Category"];
  NSString * headlineString = [prependString stringByAppendingString:@"Headline"];
  NSString * articleString = [prependString stringByAppendingString:@"Article"];
  
  Firebase *categoryRef = [myRootRef childByAppendingPath: categoryString];
  [categoryRef setValue:category];
  
  Firebase *headlineRef = [myRootRef childByAppendingPath: headlineString];
  [headlineRef setValue:headline];
  
  Firebase *articleRef = [myRootRef childByAppendingPath: articleString];
  [articleRef setValue:article];
  
  //Finally, update the number of items in the store
  Firebase *numArticlesRef = [myRootRef childByAppendingPath: @"numArticles"];
  [numArticlesRef setValue:[NSString stringWithFormat:@"%i", _numStories +1 ]];
}

@end
