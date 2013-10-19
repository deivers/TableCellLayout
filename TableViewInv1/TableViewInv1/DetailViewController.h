//
//  DetailViewController.h
//  TableViewInv1
//
//  Created by Douglas Ivers on 9/20/13.
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
