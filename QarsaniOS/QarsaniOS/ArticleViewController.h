//
//  ArticleViewController.h
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

-(void) initWithHeader: (NSString *) header andArticleText:(NSString *)articleText andImage:(UIImage*) image;

@end
