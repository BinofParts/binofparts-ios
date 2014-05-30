//
//  constants.h
//  Bin of Parts
//
//  Created by Developer on 3/1/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#ifdef DEBUG
#define kBaseURL @"http://192.168.0.10:3000/api/v1/"
#define kNoAPIURL @"http://192.168.0.10:3000/"
#else
#define kBaseURL @"https://binofparts.com/api/v1/"
#define kNoAPIURL @"https://binofparts.com/"
#endif