//
//  UIBubbleTableView.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "UIBubbleTypingTableViewCell.h"

@interface UIBubbleTableView ()

@property (nonatomic, retain) NSMutableArray *bubbleSection;
-(void)menuControllerWillHide:(NSNotification *)notification;
-(void)menuControllerWillShow:(NSNotification *)notification;
-(void)menuControllerDidShow:(NSNotification *)notification;

@end

@implementation UIBubbleTableView

@synthesize bubbleDataSource = _bubbleDataSource;
@synthesize snapInterval = _snapInterval;
@synthesize bubbleSection = _bubbleSection;
@synthesize typingBubble = _typingBubble;
@synthesize showAvatars = _showAvatars;

#pragma mark - Initializators

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;
    
    // UIBubbleTableView default properties
    
    self.snapInterval = 120;
    self.typingBubble = NSBubbleTypingTypeNobody;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuControllerWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuControllerWillShow:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuControllerDidShow:)
                                                 name:UIMenuControllerDidShowMenuNotification
                                               object:nil];
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bubbleSection release];
	_bubbleSection = nil;
	_bubbleDataSource = nil;
    [super dealloc];
}
#endif

#pragma mark - Override

- (void)reloadData
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    // Cleaning up
	self.bubbleSection = nil;
    
    // Loading new data
    int count = 0;

    self.bubbleSection = [[NSMutableArray alloc] init];
    
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
        NSMutableArray *bubbleData = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[NSBubbleData class]]);
            [bubbleData addObject:object];
        }
        
        [bubbleData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             NSBubbleData *bubbleData1 = (NSBubbleData *)obj1;
             NSBubbleData *bubbleData2 = (NSBubbleData *)obj2;
             
             return [bubbleData1.date compare:bubbleData2.date];            
         }];
        
        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            NSBubbleData *data = (NSBubbleData *)[bubbleData objectAtIndex:i];
            
            if ([data.date timeIntervalSinceDate:last] > self.snapInterval)
            {
                currentSection = [[NSMutableArray alloc] init];
                [self.bubbleSection addObject:currentSection];
            }
            
            [currentSection addObject:data];
            last = data.date;
        }
    }
    
    [super reloadData];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
	if (section >= [self.bubbleSection count]) return 1;
    return [[self.bubbleSection objectAtIndex:section] count] + 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section>=[self.bubbleSection count])
    {
        return MAX([UIBubbleTypingTableViewCell height]+7.0,self.showAvatars?63.0:7.0);
    }
    
    // Header
    if (indexPath.row == 0)
    {
        return [UIBubbleHeaderTableViewCell height];
    }
    
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    
    float cell_height=MAX(data.insets.top+data.view.frame.size.height+data.insets.bottom+7.0,data.shouldShowAvtar?63.0:7.0);
    
    return cell_height+((IS_iOS_Version_7 && (cell_height>63.0))?20.0:0.0);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't act in response to cell tap or deselect cell if showing edit menu
    if (_showingEditMenu) {
        return;
    }
    // Deselect cell after tapping
    [[self cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        static NSString *cellId = @"tblBubbleTypingCell";
        UIBubbleTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) cell = [[UIBubbleTypingTableViewCell alloc] init];

        cell.type = self.typingBubble;
        cell.showAvatar = self.showAvatars;
        
        return cell;
    }

    // Header with date and time
    if (indexPath.row == 0)
    {
        static NSString *cellId = @"tblBubbleHeaderCell";
        UIBubbleHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
        
        if (cell == nil) cell = [[UIBubbleHeaderTableViewCell alloc] init];

        cell.date = data.date;
       
        return cell;
    }
    
    // Standard bubble    
    static NSString *cellId = @"tblBubbleCell";
    UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    
    if (cell == nil) cell = [[UIBubbleTableViewCell alloc] init];
    
    cell.data = data;
    
//    UILongPressGestureRecognizer *longGest=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPressed:)];
//    longGest.minimumPressDuration=0.5;
//    [cell.contentView addGestureRecognizer:longGest];
    
    cell.showAvatar = self.showAvatars;
    
    return cell;
}

//-(void)cellLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    NSLog(@"the touch point:%@",sender);
//    NSLog(@"Cell Long Pressed...");
//    NSLog(@"Cell Long Pressed... the view %@",sender.view);
//}

#pragma mark - COPY METHODS
-(void)showSelectMenuForCell:(UIBubbleTableViewCell *)cell
{
    if ([cell isHighlighted])
    {
        UIMenuController *sharedMenu = [UIMenuController sharedMenuController];
        [cell becomeFirstResponder];
        [sharedMenu setTargetRect:cell.frame inView:self];
        [sharedMenu setMenuVisible:YES animated:YES];
        // Select cell so it doesn't become un-highlighted if finger moves off it while showing edit menu
        [self selectRowAtIndexPath:[self indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
-(void)menuControllerWillHide:(NSNotification *)notification
{
    _showingEditMenu = NO;
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}
-(void)menuControllerWillShow:(NSNotification *)notification
{
    _showingEditMenu = YES;
    self.scrollEnabled = NO;
}
-(void)menuControllerDidShow:(NSNotification *)notification
{
    self.scrollEnabled = YES;
}
-(void)copyableTableViewCell:(UIBubbleTableViewCell *)copyableTableViewCell willHighlight:(BOOL)highlighted
{
    if (highlighted)
        [self performSelector:@selector(showSelectMenuForCell:) withObject:copyableTableViewCell afterDelay:0.3];
}



@end
