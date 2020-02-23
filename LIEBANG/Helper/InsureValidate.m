//
//  InsureValidate.m
//  Storm
//
//  Created by 朱攀峰 on 15/11/25.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "InsureValidate.h"

@implementation InsureValidate

+ (NSString *)getNowTimeTimestamp {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
 }

+ (NSString *)timestamp:(NSString *)time1 {
    
    NSString *cur = [self getNowTimeTimestamp];
    NSTimeInterval curInterval = [cur doubleValue];
    
    NSTimeInterval interval;
    if (time1.length > 11) {
        interval = [time1 doubleValue]/1000;
    } else {
        interval = [time1 doubleValue];
    }
    
    return [NSString stringWithFormat:@"%f",interval-curInterval];
}

//当前时间 -- 年月日
+ (NSString*)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    [formatter setDateFormat:@"YYYY年MM月dd日"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

//当前时间 -- 年月日时分
+ (NSString*)getCurrentDetailTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
        [formatter setDateFormat:@"YYYY年MM月dd HH时mm分"];
//    [formatter setDateFormat:@"YYYY年MM月dd日"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

//当前时间 -- 年月日时分 YYYY-MM-dd HH:mm
+ (NSString*)getCurrentSubDetailTimesConvert:(NSString *)time {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //    [formatter setDateFormat:@"YYYY年MM月dd日"];
    //现在时间,你可以输出来看下是什么格式
//    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:time];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

//时间转换
+ (NSString *)timeInStr:(NSString *)string
{
    NSTimeInterval interval;
    if (string.length > 11) {
        interval = [string doubleValue]/1000;
    } else {
        interval = [string doubleValue];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

//毫秒转日期date
+ (NSDate *)timeConvertInStr:(NSString *)string
{
    NSTimeInterval interval;
    if (string.length > 11) {
        interval = [string doubleValue]/1000;
    } else {
        interval = [string doubleValue];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    return date;
}
//时间转换
+ (NSString *)timeInStr3:(NSString *)string
{
    NSTimeInterval interval;
    if (string.length > 11) {
        interval = [string doubleValue]/1000;
    } else {
        interval = [string doubleValue];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

//时间转换2
+ (NSString *)timeInStr2:(NSString *)string
{
    NSTimeInterval interval;
    if (string.length > 11) {
        interval = [string doubleValue]/1000;
    } else {
        interval = [string doubleValue];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

+ (NSString *)timeOutStr:(NSString *)string
{
    if (string.length == 16) {
        string = [NSString stringWithFormat:@"%@:00",string];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}

+ (NSString *)timeTenStr:(NSString *)string {
    
    NSString *string1 = [self timeOutStr:string];
    
    NSInteger curStr = [string1 intValue] - (10*60);
    
    return [self timeInStr:[NSString stringWithFormat:@"%zd",curStr]];
}

+(NSString*)getCurrentTimesTwo {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

//比较两个日期的大小
+ (NSString *)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    if ([bDate isEqualToString:@"至今"]) {
        bDate = [self getCurrentTimesTwo];
    }
    
    if ([bDate length] > 11) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
//    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:bDate];
    
    NSInteger aa=0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    if ([bDate length] > 11) {
        [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else {
        [dateformater setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSDate *dta = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    NSComparisonResult result = [date compare:dta];
    if (result==NSOrderedSame) {
        aa=0;//相等
        return @"0";
    }else if (result==NSOrderedAscending) {
        aa=1;//aDate比date晚
        return @"1";
    }else if (result==NSOrderedDescending) {
        aa=-1;//aDate比date早
        return @"-1";
    }
    return nil;
}


+ (NSString *)validateCertificate:(NSString *)certificateNo
{
    NSString *regex2 = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if (![identityCardPredicate evaluateWithObject:certificateNo]) {
        return @"证件号码有误，请重新输入";
    }
    return nil;
}

+ (NSString *)getBirthdayFromCertificate:(NSString *)certificateNo
{
    NSString *year = [certificateNo substringWithRange:NSMakeRange(6, 4)];
    NSString *month = [certificateNo substringWithRange:NSMakeRange(10, 2)];
    NSString *day = [certificateNo substringWithRange:NSMakeRange(12, 2)];
    NSMutableString *birthday = [[NSMutableString alloc] initWithCapacity:10];
    [birthday appendFormat:@"%@-",year];
    [birthday appendFormat:@"%@-",month];
    [birthday appendFormat:@"%@-",day];
    return birthday;
}

+ (BOOL) validateEmail:(NSString *)email
{
    NSRange range = [email rangeOfString:@".."];
    if (range.location != NSNotFound) {
        return NO;
    }
    //通用版本
    //NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    //自定义版本
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"1[0-9]{10}";//@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";//手机号以13， 15，18开头，八个 \d 数字字符
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

+ (BOOL)validateChinese:(NSString *)name
{
    if (!name || IsStrEmpty(name)) {
        return NO;
    }
   NSString *shouhuorenRegex = @"[\\u4e00-\\u9fa5]{2，10}";
    //备用[\\u4e00-\\u9fa5\\•]{2,32}
    NSPredicate *shouhuorenTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",shouhuorenRegex];
    return [shouhuorenTest evaluateWithObject:name];
}
+ (NSDate *)todayAfterSeveralMonths:(NSInteger)months andDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:(days+1)];
    [componentsToAdd setMonth:months];
    NSDate *date = [calendar dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    return date;
}

+ (NSDate *)todayAfterSeveralDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:(days+1)];
    NSDate *date = [calendar dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    return date;
}
+ (BOOL)vlidateNumber:(NSString *)number
{
   NSString *reg = @"^\\d+(\\.\\d+)?$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [numberTest evaluateWithObject:number];
}
+ (NSString *)addWhiteSpaceInStr:(NSString *)text responString:(NSString *)string range:(NSRange)range index:(int)index
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return nil;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, index)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == index) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, index)];
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    return newString;
}
+ (NSString *)addWhiteSpaceInStr:(NSString *)text responString:(NSString *)string range:(NSRange)range index:(int)index index1:(int)index1
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return nil;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger tmpindex = index;
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, tmpindex)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == tmpindex) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, tmpindex)];
        tmpindex = index1;
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    return newString;
}
+ (NSString *)deleteWhiteSpaceInStr:(NSString *)string
{
    if (IsNilOrNull(string)) {
        return @"";
    }
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [string componentsSeparatedByCharactersInSet:whiteSpace];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    string = [filteredArray componentsJoinedByString:@""];
    
    return string;
}
+ (BOOL)validateUnsignInteger:(NSString *)number
{
   NSString *codeRegex = @"[0-9]+";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:number];
}
+ (BOOL)validateInteger:(NSString *)number
{
    NSString *codeRegex = @"[0-9]{12,12}";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:number];
}
+ (NSString *)phonenum:(NSString *)phone
{
    NSRange range = {3,4};
    NSString *aString = [phone stringByReplacingCharactersInRange:range withString:@"****"];
    return aString;
}
+ (NSString *)email:(NSString *)email
{
    NSRange range1 = [email rangeOfString:@"@"];
    NSString *subStr = [email substringWithRange:NSMakeRange(0, range1.location)];
    if (subStr.length == 1) {
        NSString *aString = [NSString stringWithFormat:@"%@%@***%@",subStr,subStr,email];
        return aString;
    }
    else if (subStr.length == 2)
    {
        NSRange range = {0,subStr.length-1};
        NSString *string = [email stringByReplacingCharactersInRange:range withString:@"***"];
        NSString *aString = [NSString stringWithFormat:@"%@%@",subStr,string];
        return aString;
    }
    else
    {
        NSRange range = {2,subStr.length-3};
        NSString *aString = [email stringByReplacingCharactersInRange:range withString:@"***"];
        return aString;
    }
}
+ (NSString *)idCard:(NSString *)idCard
{
    NSRange range = {1,idCard.length-2};
    NSString *aString = [idCard stringByReplacingCharactersInRange:range withString:@"*************"];
    return aString;
}
+ (NSString *)name:(NSString *)name
{
    NSInteger nameLength = name.length - 1;
    NSString *str1 = @"";
    for (int i = 0; i < nameLength; i++) {
        NSString *str = @"*";
        str1 = [str1 stringByAppendingString:str];
    }
    NSRange range = {1,name.length-1};
    NSString *aString = [name stringByReplacingCharactersInRange:range withString:str1];
    return aString;
}
+ (NSString *)addWhiteSpaceInStrForPhoneNumber:(NSString *)phoneNumer
{
    if (phoneNumer.length == 11) {
        NSString *whiteSpaceStr = @" ";
        NSString *subStr1 = [phoneNumer substringWithRange:NSMakeRange(0, 3)];
        NSString *subStr2 = [phoneNumer substringWithRange:NSMakeRange(3, 4)];
        NSString *subStr3 = [phoneNumer substringWithRange:NSMakeRange(7, 4)];
        NSString *subStr4 = [subStr1 stringByAppendingString:whiteSpaceStr];
        NSString *subStr5 = [subStr4 stringByAppendingString:subStr2];
        NSString *subStr6 = [subStr5 stringByAppendingString:whiteSpaceStr];
        NSString *subStr7 = [subStr6 stringByAppendingString:subStr3];
        return subStr7;
    }
    else
    {
        return phoneNumer;
    }
}
+ (NSString *)deleteSpecialStr:(NSString *)string
{
   NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
    return trimmedString;
}
+ (NSString *)deleteSpecialStr1:(NSString *)string
{
    NSPredicate *set = [NSPredicate predicateWithFormat:@"SELF != '-'"];
    NSArray *parts = [string componentsSeparatedByString:@"-"];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:set];
    string  = [filteredArray componentsJoinedByString:@""];
    return string;
}
+ (NSString *)checkMobilePhoneWithStr:(NSString *)phoneStr
{
    NSString *newStr;
    NSString *deleteSpaceStr = [InsureValidate deleteWhiteSpaceInStr:phoneStr];
    NSString *deleteSpecialStr = [InsureValidate deleteSpecialStr:deleteSpaceStr];
    NSString *deleteSpecialStr1 = [InsureValidate deleteSpecialStr1:deleteSpecialStr];
    if ([deleteSpecialStr1 hasPrefix:@"86"] && [deleteSpecialStr1 length] == 13) {
        newStr = [deleteSpecialStr1 substringFromIndex:2];
        return newStr;
    }
    else if (([deleteSpecialStr1 length] == 11 && [deleteSpecialStr1 characterAtIndex:0] == '1'))
    {
        return deleteSpecialStr1;
    }
    else
    {
        return nil;
    }
}
//需要用到SFHFkeychainUtils第三方
//+ (NSString *)keychainDevice
//{
//    NSString *deviceID = @"";
//    NSString *chainDevice = [NSString]
//}
+ (BOOL)validateZipCode:(NSString *)zipCode
{
    if (zipCode.length == 6) {
        return YES;
    }
    return NO;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         NSInteger length =0;
         if (!value) {
 return NO;
 }else {
 length = value.length;
 //不满足15位和18位，即身份证错误
 if (length !=15 && length !=18) {
 return NO;
 }
 }
         // 省份代码
         NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
         
         // 检测省份身份行政区代码
         NSString *valueStart2 = [value substringToIndex:2];
         BOOL areaFlag =NO; //标识省份代码是否正确
         for (NSString *areaCode in areasArray) {
 if ([areaCode isEqualToString:valueStart2]) {
 areaFlag =YES;
 break;
 }
 }
         
         if (!areaFlag) {
 return NO;
 }
         
         NSRegularExpression *regularExpression;
         NSUInteger numberofMatch;
         
         int year =0;
         //分为15位、18位身份证进行校验
         switch (length) {
 case 15:
 //获取年份对应的数字
 year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
 
 if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
 //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
 regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
       options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
 }else {
     regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
           options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
     }
 //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
 numberofMatch = [regularExpression numberOfMatchesInString:value
   options:NSMatchingReportProgress
   range:NSMakeRange(0, value.length)];
 
 if(numberofMatch >0) {
 return YES;
 }else {
     return NO;
     }
 case 18:
 year = [value substringWithRange:NSMakeRange(6,4)].intValue;
 if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
 regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
 }else {
     regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
     }
 numberofMatch = [regularExpression numberOfMatchesInString:value
   options:NSMatchingReportProgress
   range:NSMakeRange(0, value.length)];
 
 
 if(numberofMatch >0) {
 //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
 
 int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
 
 //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
 int Y = S %11;
 NSString *M =@"F";
 NSString *JYM =@"10X98765432";
 M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
 
 NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
 
 NSLog(@"%@",M);
 NSLog(@"%@",[value substringWithRange:NSMakeRange(17,1)]);
 //4：检测ID的校验位
 if ([lastStr isEqualToString:@"x"]) {
     if ([M isEqualToString:@"X"]) {
         return YES;
         }else{
 
 return NO;
 }
     }else{
         
         if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
 return YES;
 }else {
 return NO;
 }
         
         }
 
 
 }else {
     return NO;
     }
 default:
 return NO;
 }
}
/**
 *  计算剩余时间
 *
 *  @param endTime   结束日期
 *
 *  @return 剩余时间
 */
+ (NSString *)getCountDownStringWithEndTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localDate = [now  dateByAddingTimeInterval: interval];
//    endTime = [NSString stringWithFormat:@"%@ 23:59", endTime];
    NSDate *endDate = [self timeConvertInStr:endTime];//[dateFormatter dateFromString:endTime];
    NSInteger endInterval = [zone secondsFromGMTForDate: endDate];
    NSDate *end = [endDate dateByAddingTimeInterval: endInterval];
    NSUInteger voteCountTime = ([localDate timeIntervalSinceDate:end]) / 3600 / 24;

    NSString *timeStr = [NSString stringWithFormat:@"%lu", (unsigned long)voteCountTime];
    
    return timeStr;
}
@end
