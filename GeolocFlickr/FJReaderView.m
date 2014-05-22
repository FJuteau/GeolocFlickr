//
//  FJReaderView.m
//  MengaReader
//
//  Created by orsys on 21/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "FJReaderView.h"

@implementation FJReaderView
{
    BOOL _isConfigured;
    BOOL _isAnimating;
    int _pageCounter;
}

static int identifier = 24;

// Method utilisé à l'affichage et plusieurs fois (a chaque changement d'état) ensuite dans les view (équivalent de drawrect sans la surcouche)
-(void)layoutSubviews
{
    // Pour ne l'utilisé qu'une seul fois
    if (!_isConfigured)
    {
        [self configure];
        if ([self.delegate numberOfPagesInReaderView:self])
        {
            [self showPage:0 animated:NO];
        }
        _isConfigured = YES;
    }
}


- (void) configure
{
    // Add gesture configuration
    UISwipeGestureRecognizer * swpLeft = [[UISwipeGestureRecognizer alloc] init];
    swpLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [swpLeft addTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:swpLeft];
    
    UISwipeGestureRecognizer * swpRight = [[UISwipeGestureRecognizer alloc] init];
    swpRight.direction = UISwipeGestureRecognizerDirectionRight;
    [swpRight addTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:swpRight];
    
    _pageCounter = 0;
    
}

- (void) showPage:(int)index animated:(BOOL)isAnimated
{
    // Utilisé pour ne pas faire deux animation en même temps
    if (_isAnimating) return;
    
    UIView *pageToDisplay, *pageToRemove;
    
    pageToRemove = [self viewWithTag:identifier];
    
    pageToDisplay = [self.delegate readerView:self pageAtIndex:index];
    pageToDisplay.frame = self.bounds;
    
    pageToDisplay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // On met un identifiant pour garder chaque élément séparément (ici le même tag pour toute les pages)
    pageToDisplay.tag = identifier;
    [self addSubview:pageToDisplay];
    
    if (isAnimated)
    {
        _isAnimating = YES;
        float offsetX = pageToDisplay.bounds.size.width;
        if(index > _pageCounter) offsetX *= -1;
        
        pageToDisplay.center = CGPointMake(pageToDisplay.center.x - offsetX, pageToDisplay.center.y);
        
        [UIView animateWithDuration:.3
                         animations:^
         {
             pageToDisplay.center = CGPointMake(pageToDisplay.center.x + offsetX, pageToDisplay.center.y);
             pageToRemove.center = CGPointMake(pageToRemove.center.x + offsetX, pageToRemove.center.y);
         }
                         completion:^(BOOL done)
         {
             
             [pageToRemove removeFromSuperview];
             _isAnimating = NO;
         }];
    }
    else
    {
        [pageToRemove removeFromSuperview];
    }
    
    _pageCounter = index;
}

- (void) handleSwipe:(UISwipeGestureRecognizer*) sender
{
    int tempCounter = -1;
    
    BOOL isDisplayingFirstPage = (_pageCounter == 0);
    BOOL isDisplayingLastPage = (_pageCounter == [self.delegate numberOfPagesInReaderView:self] - 1);
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && !isDisplayingLastPage)
    {
        tempCounter = _pageCounter + 1;
        NSLog(@"Page up: %d", _pageCounter);
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight && !isDisplayingFirstPage)
    {
        tempCounter = _pageCounter - 1;
        NSLog(@"Page down: %d", _pageCounter);
    }
    
    if (tempCounter != -1)
    {
        [self showPage:tempCounter animated:YES];
    }
    else if (_pageCounter >= 0)
    {
        [self bounce];
    }
    
}

- (void) bounce
{
    UIView * page = [self viewWithTag:identifier];
    
    // On bound de 1/5 de la largeur de l'écran
    float offsetX = (page.bounds.size.width / 5);
    
    // On change le sens si ce n'est pas la première page
    if(_pageCounter != 0) offsetX *= -1;
    
    [UIView animateWithDuration:.3
                     animations:^
     {
         page.center = CGPointMake(page.center.x + offsetX, page.center.y);
     }
                     completion:^(BOOL done)
     {
         [UIView animateWithDuration:.3
                          animations:^(void)
          {
              page.center = CGPointMake(page.center.x - offsetX, page.center.y);
          }];
     }];
}
@end
