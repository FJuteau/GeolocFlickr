//
//  FJReaderView.h
//  MengaReader
//
//  Created by orsys on 21/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJReaderViewDelegate <NSObject>

- (UIView *) readerView:(id)sender pageAtIndex:(int)index;
- (int) numberOfPagesInReaderView:(id)readerView;

@end

@interface FJReaderView : UIView

// La classe qui voudra être delegate devra se conformé au protocole <FRReaderViewDelegate>
@property (weak, nonatomic) id<FJReaderViewDelegate> delegate;
@property (readonly, nonatomic) int PageCounter;

- (void) showPage:(int)index animated:(BOOL)isAnimated;
@end