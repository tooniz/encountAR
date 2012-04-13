//
// IACommentCell.m
// Disquser
// 
// Copyright (c) 2011 Ikhsan Assaat. All Rights Reserved 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "IACommentCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation IACommentCell

@synthesize imageView, nameLabel, dateLabel, commentLabel; 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextColor:[UIColor colorWithWhite:0.375 alpha:1.0]];
        [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setTextColor:[UIColor colorWithWhite:0.44 alpha:1.0]];
        [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:dateLabel];
        
        commentLabel = [[UILabel alloc] init];
        [commentLabel setTextColor:[UIColor colorWithWhite:0.44 alpha:1.0]];
        [commentLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [commentLabel setMinimumFontSize:12.0];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        [commentLabel setLineBreakMode:UILineBreakModeWordWrap];
        [commentLabel setNumberOfLines:0];
        [self.contentView addSubview:commentLabel];
        
        imageView = [[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setBackgroundColor:[UIColor lightGrayColor]];
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setOpaque:NO];
        [imageView.layer setCornerRadius:5.0];
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [imageView setFrame:CGRectMake(4.0, 8.0, 44.0, 44.0)];
    [nameLabel setFrame:CGRectMake(60.0, 8.0, 200.0, 20.0)];
    [dateLabel setFrame:CGRectMake(60.0, 32.0, 200.0, 15.0)];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    UIColor *startColor = [UIColor colorWithRed:0.96 green:.97 blue:.98 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    // set bottom line
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.79 green:0.82 blue:0.85 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0.0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
    // set top line
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, rect.size.width, 0.0);
    CGContextStrokePath(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)dealloc {
    [nameLabel release];
    [imageView release];
    [dateLabel release];
    [commentLabel release];
    [super dealloc];
}

@end
