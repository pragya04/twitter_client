//
//  User.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "Mantle.h"

@interface User : MTLModel <MTLJSONSerializing>
@property (nonatomic) NSString *userImage;
@property (nonatomic) NSString *userNameLabel;
@property (nonatomic) NSString *userScreenName;
@end
