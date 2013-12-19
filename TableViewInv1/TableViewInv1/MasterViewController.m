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

#define FIX_WORD_WRAP
#define FIX_CELL_HEIGHT
//#define FIX_CELL_DEQUEUED_WIDTH
//#define FIX_HEADER_HEIGHT


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
        [_objects addObject:@"abc def ghi abc def ghi abc def ghi abc def ghi jkl"];
        [_objects addObject:@"123 456 789 123 456 789"];
    }
}

#ifdef RELOAD_ON_ROTATION
-(void)viewDidAppear:(BOOL)animated {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        [self resetHeaderAndReload];        // fix for when the table initially loads in landscape
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resetHeaderAndReload];
}
#endif

-(void)resetHeaderAndReload {
#ifdef FIX_HEADER_HEIGHT
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.headerView; // workaround for the fact that reloadData does not reset the table header height
#endif
    NSLog(@"  %@:%@:%d\n    Reloading table",[self class],NSStringFromSelector(_cmd),__LINE__);
    [self.tableView reloadData];
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
    NSLog(@"  %@:%@:%d\n    cell width: %f",[self class],NSStringFromSelector(_cmd),__LINE__,cell.frame.size.width);
    [cell populateCell:_objects[indexPath.row]];
    return cell;
}

#pragma-mark UITableViewDataSource methods and support

#ifdef FIX_CELL_HEIGHT
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.nominalCell populateCell:_objects[indexPath.row]];
    [self.nominalCell setNeedsLayout];
    [self.nominalCell layoutIfNeeded];
    CGFloat cellHeight = [self cellHeightThatFits:tableView.frame.size.width];
    NSLog(@"  %@:%@:%d\n    cell height that hugs content: %f  for width: %f",[self class],NSStringFromSelector(_cmd),__LINE__, cellHeight, tableView.frame.size.width);
    return cellHeight;
}

-(CGFloat)cellHeightThatFits:(CGFloat)width {
    return [self.nominalCell.contentView systemLayoutSizeFittingSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

-(MasterViewCell *)nominalCell {
    if (!_nominalCell) {
        _nominalCell = (MasterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"thecell"];  // get a nominal cell for the purpose of layout and cell height
    }
    _nominalCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, APOSITIVENUMBER);  // make sure the cell has the same with that the table currently has
    return _nominalCell;
}
#endif

@end



@implementation MasterViewCell

-(void)populateCell:(NSString *)displayString {
    self.label2.text = displayString;
}

-(void)layoutSubviews {
    // see WWDC2012 #228 46 minute mark
    [super layoutSubviews];
#ifdef FIX_WORD_WRAP
    self.label2.preferredMaxLayoutWidth = self.label2.frame.size.width;
#endif
}

@end



@implementation HeaderView

-(void)layoutSubviews {
    [super layoutSubviews];
#ifdef FIX_WORD_WRAP
    self.label0.preferredMaxLayoutWidth = self.label0.frame.size.width;
#endif
#ifdef FIX_HEADER_HEIGHT
    CGFloat viewHeight = (self.superview.frame.size.width > 320) ? 80 : 100;  // todo: figure out how to get height from the layout system
    self.frame = CGRectMake(0, 0, self.superview.frame.size.width, viewHeight);
    [super layoutSubviews];
#endif
}

@end
