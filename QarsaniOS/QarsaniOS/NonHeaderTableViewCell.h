//
//  NonHeaderTableViewCell.h
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#ifndef NONHEADERTABLEVIEWCELL_H
#define NONHEADERTABLEVIEWCELL_H

#import <UIKit/UIKit.h>

@interface NonHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *HeaderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CategoryImage;

-(void) setHeadline:(NSString *)headline andArticle:(NSString *) article andCategory:(NSString *)category;
-(NSString *) getHeader;
-(NSString *) getArticle;

@end

#endif