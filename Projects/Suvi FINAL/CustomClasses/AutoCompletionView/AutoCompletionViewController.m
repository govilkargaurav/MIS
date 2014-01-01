//
//  AutoCompletionViewController.m
//  Suvi
//
//  Created by Gagan Mishra on 2/25/13.
//
//

#import "AutoCompletionViewController.h"
#import "AutocompletionTableView.h"

@interface AutoCompletionViewController ()

@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@end

@implementation AutoCompletionViewController
@synthesize autoCompleter = _autoCompleter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrsuggestion=[[NSMutableArray alloc]init];
    
    btnDropDownMask=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 480+iPhone5ExHeight)];
    [self.view addSubview:btnDropDownMask];
    btnDropDownMask.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.1];
    btnDropDownMask.hidden=YES;
    
    [txtsearchname addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:txtsearchname inViewController:self withOptions:options];
        _autoCompleter.suggestionsDictionary =arrsuggestion;
    }
    return _autoCompleter;
}

#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return arrsuggestion;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index
{
    [txtsearchname resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==txtsearchname)
    {
        btnDropDownMask.hidden=NO;
        [self.autoCompleter showSuggestionsForString:txtsearchname.text];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txtsearchname)
    {
        btnDropDownMask.hidden=YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    if (textField==txtsearchname)
    {
        self.autoCompleter.hidden=YES;
    }
    
    [textField resignFirstResponder];
	return TRUE;
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
