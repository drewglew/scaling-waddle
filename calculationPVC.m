//
//  calculationPVC.m
//  RoastChicken
//
//  Created by andrew glew on 23/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "calculationPVC.h"
#import "dbHelper.h"

@interface calculationPVC () <UIPageViewControllerDelegate, calcDetailDelegate>

@end


@implementation calculationPVC

@synthesize delegate;
@synthesize db;
@synthesize pageIndex;
@synthesize opencalcs;
@synthesize total;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PageViewController.delegate = self;
    // Do any additional setup after loading the view.
    if ([self.opencalcs count]==0) {
        //[self.opencalcs add
        //newData = [[NSMutableArray alloc] init];
         self.opencalcs = [[NSMutableArray alloc] init];
    }
    [self.opencalcs addObject:self.c];
    
    calculationDetailVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
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

- (calculationDetailVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.opencalcs count] == 0) || (index >= [self.opencalcs count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    calculationDetailVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.currentpageindex = index;
    pageContentViewController.c = self.c;
    pageContentViewController.db = self.db;
    pageContentViewController.currentpageindex = index;
    return pageContentViewController;
}


-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    self.total =  (int)[self.opencalcs count];
    return [self.opencalcs count];
}


- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSString * identifier = viewController.restorationIdentifier;
    NSUInteger index = [self.opencalcs indexOfObject:identifier];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSString * identifier = viewController.restorationIdentifier;
    NSUInteger index = [self.opencalcs indexOfObject:identifier];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.opencalcs count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}





@end
