//
//  ArticleViewController.m
//  QarsaniOS
//
//  Created by Michael Weingert on 2015-04-11.
//  Copyright (c) 2015 PBC. All rights reserved.
//

#import "ArticleViewController.h"
//#import "FirebaseManager.h"

@interface ArticleViewController ()
{
  NSString *_header;
  NSString *_article;
  UIImage *_image;
}

@property (weak, nonatomic) IBOutlet UILabel *HeaderLabel;
@property (weak, nonatomic) IBOutlet UITextView *ArticleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eyePatchImage;

@end

@implementation ArticleViewController

-(void) initWithHeader: (NSString *) header andArticleText:(NSString *)articleText andImage:(UIImage *)image
{
  _header = header;
  _article = articleText;
  _image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _ArticleLabel.text = _article;
  _HeaderLabel.text = _header;
  _ArticleLabel.editable = NO;
  _eyePatchImage.image = _image;

  _HeaderLabel.numberOfLines = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
