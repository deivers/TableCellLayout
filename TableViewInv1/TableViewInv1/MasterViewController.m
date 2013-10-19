//
//  MasterViewController.m
//  TableViewInv1
//
//  Created by Douglas Ivers on 9/20/13.
//
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#define APOSITIVENUMBER 10
//#define FIX_WORD_WRAP
//#define FIX_CELL_HEIGHT
//#define FIX_HEADER_HEIGHT


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
        [_objects addObject:@"abc def ghi abc def ghi abc def ghi abc def ghi jkl"];
        [_objects addObject:@"123 456 789 123 456 789"];
    }
}

- (void)insertNewObject:(id)sender {
    [_objects insertObject:[NSDate date].description atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thecell"];
    [cell populateCell:_objects[indexPath.row]];
    return cell;
}

#pragma-mark UITableViewDataSource methods and support

#ifdef FIX_CELL_HEIGHT
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.nominalCell populateCell:_objects[indexPath.row]];
    [self.nominalCell setNeedsLayout];
    [self.nominalCell layoutIfNeeded];
    CGFloat cellHeight = [self.nominalCell.contentView systemLayoutSizeFittingSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)].height;
    NSLog(@"  %@:%@:%d\n    %f",[self class],NSStringFromSelector(_cmd),__LINE__, cellHeight);
    return cellHeight;
}

- (MasterViewCell *)nominalCell {
    if (!_nominalCell) {
        _nominalCell = (MasterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"thecell"];  // get a nominal cell for the purpose of layout and cell height
    }
    _nominalCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, APOSITIVENUMBER); // workaround for Apple bug - dequeued cell width doesn't match table width in landscape
    _nominalCell.contentView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, APOSITIVENUMBER); // workaround for Apple bug - dequeued cell width doesn't match table width in landscape
    return _nominalCell;
}
#endif

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
#ifdef FIX_HEADER_HEIGHT
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.headerView; // workaround for the fact that reloadData does not reset the table header height
#endif
    [self.tableView reloadData];
}

@end



@implementation MasterViewCell

- (void)populateCell:(NSString *)displayString {
    self.label2.text = displayString;
}

- (void)layoutSubviews {
    // see WWDC2012 #228 46 minute mark
    [super layoutSubviews];
#ifdef FIX_WORD_WRAP
    //NSLog(@"width before: %f",self.label2.preferredMaxLayoutWidth);
    self.label2.preferredMaxLayoutWidth = self.label2.frame.size.width;
    //NSLog(@"width after:  %f",self.label2.preferredMaxLayoutWidth);
#endif
}

@end



@implementation HeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
#ifdef FIX_WORD_WRAP
    //NSLog(@"width before: %f",self.label0.preferredMaxLayoutWidth);
    self.label0.preferredMaxLayoutWidth = self.label0.frame.size.width;
    //NSLog(@"width after:  %f",self.label0.preferredMaxLayoutWidth);
#endif
#ifdef FIX_HEADER_HEIGHT
    CGFloat viewHeight = (self.superview.frame.size.width > 320) ? 80 : 100;
    self.frame = CGRectMake(0, 0, self.superview.frame.size.width, viewHeight);
    [super layoutSubviews];
    NSLog(@"  %@:%@:%d\n    width: %f  height: %f",[self class],NSStringFromSelector(_cmd),__LINE__, self.frame.size.width, self.frame.size.height);
#endif
}

@end