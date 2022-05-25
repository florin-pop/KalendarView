//
//  KalendarView.swift
//
//
//  Created by Florin Pop on 07.07.20.
//

import SwiftUI

public struct KalendarView<Accessory: View>: View {
    @State private var title: String = ""

    let fromDate: Date
    let toDate: Date
    let scrollToBottom: Bool
    let accessoryBuilder: (_ date: Date) -> Accessory

    var selection: KalendarSelection

    private var months: [Date] {
        let months = (0 ... fromDate.months(to: toDate)).map { self.fromDate.dateByAdding(months: $0) }
        return months
    }

    public init(fromDate: Date, toDate: Date, scrollToBottom: Bool = false, selection: KalendarSelection, @ViewBuilder accessoryBuilder: @escaping (_ date: Date) -> Accessory) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.scrollToBottom = scrollToBottom
        self.selection = selection
        self.accessoryBuilder = accessoryBuilder
    }

    public var body: some View {
        Group {
            KalendarTitleView(title: self.$title)
            Divider()
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    LazyVStack {
                        ForEach(self.months, id: \.self) { month in
                            VStack {
                                MonthView(month: month, selection: self.selection, accessoryBuilder: self.accessoryBuilder)
                            }
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewOffsetKey.self,
                                                       value: -$0.frame(in: .named("scroll")).origin.y + $0.size.height / 2)
                            })
                            .onPreferenceChange(ViewOffsetKey.self) { offsetY in
                                if offsetY > 0 {
                                    let currentMonth = month.formatMonthAndYear()
                                    if title != currentMonth {
                                        title = currentMonth
                                    }
                                }
                            }
                        }
                    }.onAppear {
                        guard let lastMonth = self.months.last, self.scrollToBottom else { return }
                        scrollViewProxy.scrollTo(lastMonth, anchor: .bottom)
                    }
                }
            }.coordinateSpace(name: "scroll")
        }
    }
}

extension KalendarView where Accessory == EmptyView {
    public init(fromDate: Date, toDate: Date, scrollToBottom: Bool = false, selection: KalendarSelection) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.scrollToBottom = scrollToBottom
        self.selection = selection
        self.accessoryBuilder = { _ in EmptyView() }
    }

    func buildContent<Accessory: View>(@ViewBuilder content: () -> Accessory) -> KalendarView<EmptyView> {
        KalendarView<EmptyView>(fromDate: fromDate, toDate: toDate, selection: selection) { _ in
            EmptyView()
        }
    }
}

private struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KalendarView(fromDate: Date(), toDate: Date().addingTimeInterval(60*60*24*365), selection: KalendarSelection())
            KalendarView(fromDate: Date(), toDate: Date().addingTimeInterval(60*60*24*32), selection: KalendarSelection())
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
