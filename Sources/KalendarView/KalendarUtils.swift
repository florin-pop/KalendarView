//
//  KalendarUtils.swift
//
//
//  Created by Florin Pop on 08.07.20.
//

import SwiftUI
import UIKit

private let currentCalendar = Calendar.current

extension CGFloat {
    static var cellWidth: CGFloat { 32 }
    static var cellHeight: CGFloat { 32 }
}

extension View {
    func fitWidthInCalendarCell() -> some View {
        return self.frame(minWidth: .cellWidth, maxWidth: .cellWidth)
    }

    func fitHeightInCalendarCell() -> some View {
        return self.frame(minHeight: .cellHeight, maxHeight: .cellHeight)
    }
}

extension Color {
    static let textForeground = Color.primary
    static let todayForeground = Color.white

    static let textBackground = Color.clear
    static let todayBackground = Color.red
}

extension DateFormatter {
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    static let month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()

    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL YYYY"
        return formatter
    }()

    static let weekdaySymbols: [String] = {
        let formatter = DateFormatter()
        return formatter.veryShortStandaloneWeekdaySymbols.shifted(by: currentCalendar.firstWeekday - 1)
    }()
}

extension Date {
    func formatDayOfMonth() -> String {
        return DateFormatter.day.string(from: self)
    }

    func formatMonth() -> String {
        return DateFormatter.month.string(from: self)
    }

    func formatMonthAndYear() -> String {
        return DateFormatter.monthAndYear.string(from: self)
    }

    func isToday() -> Bool {
        return currentCalendar.isDateInToday(self)
    }

    func isBeginningOfMonth() -> Bool {
        return currentCalendar.component(.day, from: self) == 1
    }

    func isSameMonth(as date: Date) -> Bool {
        return currentCalendar.isDate(self, equalTo: date, toGranularity: .month)
    }

    func dateAtBeginningOfWeek() -> Date {
        return currentCalendar.date(from: currentCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    func dateByAdding(days: Int) -> Date {
        return currentCalendar.date(byAdding: .day, value: days, to: self)!
    }

    func dateByAdding(months: Int) -> Date {
        return currentCalendar.date(byAdding: .month, value: months, to: self)!
    }

    func months(to date: Date) -> Int {
        return currentCalendar.dateComponents([.month], from: self, to: date).month ?? 0
    }

    func weeksInMonth() -> [[Date]] {
        let daysInWeek = 7
        var components = currentCalendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1

        let firstOfMonth = currentCalendar.date(from: components)!
        let begin = firstOfMonth.dateAtBeginningOfWeek()
        let weeksInMonth = currentCalendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)!.count
        let daysInMonth = weeksInMonth * daysInWeek

        return (0..<daysInMonth).map { begin.dateByAdding(days: $0) }.chunked(into: daysInWeek)
    }
}

extension Array {
    // From https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }

    public func shifted(by index: Int) -> Array {
        return Array(self[index..<self.count] + self[0..<index])
    }
}
