//
//  NSString+Time.m
//  LIEBANG
//
//  Created by  YIQI on 2018/11/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

//判断时间是否是今天 昨天 星期几 几月几日
+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString;
{
    if (!timeString || timeString.length < 10) {
        return @"时间未知";
    }
    //将时间戳转为NSDate类
    NSTimeInterval time = [[timeString substringToIndex:10] doubleValue];
    NSDate *inputDate=[NSDate dateWithTimeIntervalSince1970:time];
    //
    NSString *lastTime = [self compareDate:inputDate];
    return lastTime;
}

+ (NSString *)compareDate:(NSDate *)inputDate{
    
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger goalInterval = [zone secondsFromGMTForDate: inputDate];
    NSDate *date = [inputDate  dateByAddingTimeInterval: goalInterval];
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSInteger localInterval = [zone secondsFromGMTForDate: currentDate];
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: localInterval];
    
    //今天／昨天／前天
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today = localeDate;
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSDate *beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    //今年
    NSString *toYears = [[today description] substringToIndex:4];
    
    //目标时间拆分为 年／月
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];//05-23 06:22
        NSString *time3 = [[date description] substringWithRange:(NSRange){5,5}];//05-23
        if ([dateString isEqualToString:todayString]){
            //今天
            dateContent = [NSString stringWithFormat:@"%@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            //昨天
            dateContent = [NSString stringWithFormat:@"昨天"];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            //前天
            dateContent = [NSString stringWithFormat:@"前天"];
            return dateContent;
        }else{
            if ([self compareDateFromeWorkTimeToNow:time2]) {
                //一周之内，显示星期几
                return [[self class] weekdayStringFromDate:inputDate];
            }else{
                //一周之外，显示“月-日 时：分” ，如：05-23 06:22
                return time3;
            }
        }
    }else{
        //不同年，显示具体日期：如，2008-11-11
        return dateString;
    }
}

//比较在一周之内还是之外
+ (BOOL)compareDateFromeWorkTimeToNow:(NSString *)timeStr
{
    //获得当前时间并转为字符串 2017-07-16 07:54:36 +0000(NSDate类)
    NSDate *currentDate = [NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//实例化时间格式类
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//格式化
    NSString *timeString = [df stringFromDate:currentDate];
    timeString = [timeString substringFromIndex:5];
    
    int today = [timeString substringWithRange:(NSRange){3,2}].intValue;
    int workTime = [timeStr substringWithRange:(NSRange){3,2}].intValue;
    if ([[timeStr substringToIndex:2] isEqualToString:[timeString substringToIndex:2]]) {
        if (today - workTime <= 6) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

//返回星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
