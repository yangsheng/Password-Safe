//
//  Generator.m
//  PasswordSafe
//
//  Created by CSSE Department on 12/13/12.
//  Copyright (c) 2012 Software Security Consultants Incorporated. All rights reserved.
//

#import "Generator.h"

@implementation Generator

- (id)init {
    self = [super init];
    if (self){
        charPool = [NSArray arrayWithObjects: @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"!",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"_",@"-",@"+",@"=",@"{",@"}",@"[",@"]",@":",@";",@"<",@">", nil];
    }
    return self;
}


-(NSMutableString*)generatePassword: (int)length: (int)numCaps: (int)numLowers: (int)numSpecials: (int)numNums:
(Boolean)caps: (Boolean)lowers: (Boolean)specs: (Boolean)nums{
//    if ((numCaps + numLowers + numSpecials + numNums) > length){
//
//    }
    // TODO error checking
    int Caps = -1;
    int Lowers = -1;
    int Specials = -1;
    int Nums = -1;
    
    if (nums) Nums = numNums;
    if (lowers) Lowers = numLowers;
    if (caps) Caps = numCaps;
    if (specs) Specials = numSpecials;
    
    NSMutableArray *passwordArray = [[NSMutableArray alloc] init];
    NSMutableString *password = [[NSMutableString alloc] init];
    int count = 0;
    while (count < length){
        int pos = arc4random_uniform([charPool count]);
        NSString* character = [charPool objectAtIndex:pos];
        int ascii = [character characterAtIndex:0];
        if ([self isCapital:ascii] && Caps > 0){
            [passwordArray addObject:character];
            Caps--;
            count++;
        }
        else if ([self isLower:ascii] && Lowers > 0){
            [passwordArray addObject:character];
            Lowers--;
            count++;
        }
        else if ([self isSpecial:ascii] && (Specials > 0)){
            [passwordArray addObject:character];
            Specials--;
            count++;
        }
        else if ([self isNumber:ascii] && Nums > 0){
            [passwordArray addObject:character];
            Nums--;
            count++;
        }
        else if ((Caps <= 0) && (Lowers <= 0) && (Specials <= 0) && (Nums <= 0)){
            if ([self isCapital:ascii] && Caps == 0){
                [passwordArray addObject:character];
                count++;
            }
            else if ([self isLower:ascii] && Lowers == 0){
                [passwordArray addObject:character];
                count++;
            }
            else if ([self isSpecial:ascii] && Specials == 0){
                [passwordArray addObject:character];
                count++;
            }
            else if ([self isNumber:ascii] && Nums == 0){
                [passwordArray addObject:character];
                count++;
            }
        }
    }
    passwordArray = [self knuthShuffle:passwordArray :length];
    
    for (int i = 0; i < length; i++) {
        [password appendString: [passwordArray objectAtIndex:i]];
    }
    return password;
}

-(NSMutableArray*)knuthShuffle: (NSMutableArray *)password: (int)length{
    for (int i = 0; i < length; i++){
        int pos = arc4random_uniform(length);
        NSString* temp = password[i];
        [password replaceObjectAtIndex:i withObject:[password objectAtIndex:pos]];
        [password replaceObjectAtIndex:pos withObject:temp];
        password[pos] = temp;
    }
    return password;
}

-(Boolean)isCapital: (int)ascii{
    return (ascii > 64 && ascii < 91);
}

-(Boolean)isLower:(int)ascii{
    return (ascii > 96 && ascii < 123);
}

-(Boolean)isSpecial: (int)ascii{
    return (ascii == 21) || (ascii > 34 && ascii < 39) || (ascii > 39 && ascii < 47) || (ascii > 57 && ascii < 65) ||
            (ascii > 90 && ascii < 96) || (ascii == 123) || (ascii == 125);
}

-(Boolean)isNumber: (int)ascii{
    return (ascii > 47 && ascii < 58);
}
-(int)countUpperCaseCharacters: (NSMutableString*)string{
    int count=0;
    int i=0;
    for (i = 0; i < [string length]; i++) {
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:i]];
        if (isUppercase == YES)
            count++;
    }
    return count;
}
-(int)countLowerCaseCharacters: (NSMutableString*)string{
    int count=0;
    int i=0;
    for (i = 0; i < [string length]; i++) {
        BOOL isUppercase = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:i]];
        if (isUppercase == YES)
            count++;
    }
    return count;
}

-(int)countSpecialCaseCharacters: (NSMutableString*)string{
    int count = 0;
    int i = 0;
    for(i=0; i<[string length]; i++){
        if([self isSpecial: [string characterAtIndex:i]]){
            count++;
        }
    }
    return count;
}
-(int)countNumbers: (NSMutableString*)string{
    int count = 0;
    int i = 0;
    for(i=0; i<[string length]; i++){
        if([self isNumber: [string characterAtIndex:i]]){
            count++;
        }
    }
    return count;
}

@end