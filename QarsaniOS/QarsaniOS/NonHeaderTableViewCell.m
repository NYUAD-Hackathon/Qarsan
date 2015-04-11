//
//  NonHeaderTableViewCell.m
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#import "NonHeaderTableViewCell.h"

@implementation NonHeaderTableViewCell
{
  NSString *_article;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setHeadline:(NSString *)headline andArticle:(NSString *) article andCategory:(NSString *)category
{
  self.HeaderLabel.text = headline;
  //self.CategoryImage.layer.cornerRadius = self.CategoryImage.frame.size.width / 2.0;
  //self.CategoryImage.backgroundColor = [UIColor redColor];
  if ([category isEqualToString:@"Women"])
  {
    self.CategoryImage.image = [UIImage imageNamed:@"eyepatch_olive.png"];
  } else if ([category isEqualToString:@"World"]) {
    self.CategoryImage.image = [UIImage imageNamed:@"eyepatch2_gray.png"];
  } else if ([category isEqualToString:@"Middle East"]){
    self.CategoryImage.image = [UIImage imageNamed:@"eyepatch3_red.png"];
  }
  _article = article;
}

-(NSString *) getHeader
{
  return _HeaderLabel.text;
}

-(NSString *) getArticle
{
  return _article;
}

@end
