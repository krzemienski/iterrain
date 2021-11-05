//
//  Customer.h
//  MAW
//
//  Created by Sean O'Shea on 10/14/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Form1, Form2;

@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * cell;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * county;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first;
@property (nonatomic, retain) NSString * first2;
@property (nonatomic, retain) NSString * inspector;
@property (nonatomic, retain) NSString * last;
@property (nonatomic, retain) NSString * last2;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * referedBy;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * work;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * widget1;
@property (nonatomic, retain) NSString * widget2;
@property (nonatomic, retain) NSString * widget3;
@property (nonatomic, retain) NSString * widget4;
@property (nonatomic, retain) Form1 *form1;
@property (nonatomic, retain) Form2 *form2;

@end
