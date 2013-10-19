//
//  MasterViewController.h
//  TableViewInv1
//
//  Created by Douglas Ivers on 9/20/13.
//
//

#import <UIKit/UIKit.h>

@class MasterViewCell;
@class HeaderView;

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) MasterViewCell *nominalCell;
@property (nonatomic, weak) IBOutlet HeaderView *headerView;

@end


@interface MasterViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;

- (void)populateCell:(NSString *)displayString;

@end


@interface HeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *label0;

@end