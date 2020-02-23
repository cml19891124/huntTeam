/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

typedef NS_ENUM(NSInteger, NSCalendarWeekDay)
{
    NSCalendarWeekDayOnSunday = 1,
    NSCalendarWeekDayOnMonday,
    NSCalendarWeekDayOnTuesday,
    NSCalendarWeekDayOnWednesday,
    NSCalendarWeekDayOnThursday,
    NSCalendarWeekDayOnFriday,
    NSCalendarWeekDayOnSaturday,
};//日历的星期，之所以使用该顺序，是为了匹配ios系统设置，iOS中规定的就是周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7

@interface NSDate (Utilities)
+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

//所在月的第一天
- (NSDate *) firstDayInMonth;
//所在天的0点0分0秒
- (NSDate *) dateAtStartOfDay;
//所在天的23点59分59秒
- (NSDate *) dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

/**
 *  所在天在指定星期几开始的那一周内是第几天
 *
 *  @param startWeekDay 月份指定以星期几开始
 *
 *  @return 返回值为1时表示第一天,为7时表示第7天.范围[1~7]
 */
- (NSInteger) indexOfWeekWithStartWeekDay:(NSCalendarWeekDay)startWeekDay;

/**
 *  所在月有多少天
 *  1、3、5、7、8、10、12为31天；
 *  4、6、9、11为30天；
 *  2月为28或者29天；
 */
- (NSInteger)numDaysInMonth;

// Decomposing dates
@property (readonly) NSInteger year;
@property (readonly) NSInteger month;
@property (readonly) NSInteger day;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger nearestHour;//最接近的小时
@property (readonly) NSInteger weekOfMonth;//所属月的第几个星期 索引从1开始 【系统默认每周以周日开始，可通过[[NSDate currentCalendar] setFirstWeekday:NSCalendarWeekDay]设置每周起始星期】
@property (readonly) NSInteger weekOfYear;//所属年的第几个星期  索引从1开始 【系统默认每周以周日开始，可通过[[NSDate currentCalendar] setFirstWeekday:NSCalendarWeekDay]设置每周起始星期】
@property (readonly) NSCalendarWeekDay weekday;//星期几  [注:iOS中规定的就是周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7]
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2,这个月的第几个星期X  索引从1开始

@end


/*
 *   该类取自Github，但已年久失修；改类在最新代码上有新API增加和旧API维护，请勿随意覆盖或修改该类。wei.zhang 2016-05-16
 */
