//
//  KalendarView.swift
//  
//
//  Created by Florin Pop on 07.07.20.
//

import SwiftUI

struct KalendarView<Accessory: View>: View {
    @State private var title: String = ""
    @State private var scrollOffset: CGPoint = .zero
    
    let fromDate: Date
    let toDate: Date
    let scrollToBottom: Bool
    let accessoryBuilder: (_ date: Date) -> Accessory
    
    var selection: KalendarSelection
    
    private var rotationEffectAngle: Angle {
        self.scrollToBottom ? .pi : .zero
    }
    private var scaleEffectX: CGFloat {
        self.scrollToBottom ? -1 : 1
    }
    
    private var months: [Date] {
        let months = (0...fromDate.months(to: toDate)).map{ self.fromDate.dateByAdding(months: $0) }
        return scrollToBottom ? months.reversed() : months
    }
    
    init(fromDate: Date, toDate: Date, scrollToBottom: Bool = false, selection: KalendarSelection, @ViewBuilder accessoryBuilder: @escaping (_ date: Date) -> Accessory) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.scrollToBottom = scrollToBottom
        self.selection = selection
        self.accessoryBuilder = accessoryBuilder
    }
    
    
    
    var body: some View {
        Group {
            KalendarTitleView(title: self.$title)
            Divider()
            ScrollView {
                VStack {
                    ForEach(self.months, id: \.self) { month in
                        VStack {
                            MonthView(month: month, selection: self.selection, accessoryBuilder: self.accessoryBuilder)
                        }
                        .provideFrameChanges(viewId: month.formatMonthAndYear())
                    }
                        .rotationEffect(self.rotationEffectAngle) // rotate each item
                        .scaleEffect(x: scaleEffectX, y: 1, anchor: .center) // and flip it so we can flip the container to keep the scroll indicators on the right
                }
                
            }
                                .rotationEffect(self.rotationEffectAngle) // rotate the whole ScrollView 180º
                                .scaleEffect(x: scaleEffectX, y: 1, anchor: .center) // flip it so the indicator is on the right
                .handleViewTreeFrameChanges { self.onScroll($0) }
        }
    }
    
    
    
    private func onScroll(_ viewTreeChanges: ViewTreeFrameChanges) {
        var minY: CGFloat = .infinity
        var currentMonth = ""
        
        for (month, frame) in viewTreeChanges {
            if frame.minY >= -frame.height / 2 // bottom half of the month is visible
                && frame.minY <= minY { // topmost month
                minY = frame.minY
                currentMonth = month
            }
        }
        if self.title != currentMonth {
            self.title = currentMonth
        }
    }
}

extension KalendarView where Accessory == EmptyView {
    init(fromDate: Date, toDate: Date, scrollToBottom: Bool = false, selection: KalendarSelection) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.scrollToBottom = scrollToBottom
        self.selection = selection
        self.accessoryBuilder = { _ in EmptyView() }
    }
    
    func buildContent<Accessory: View>(@ViewBuilder content: () -> Accessory) -> KalendarView<Accessory> {
        KalendarView<Accessory>(fromDate: fromDate, toDate: toDate, selection: selection) { _ in
            EmptyView() as! Accessory
        }
    }
}

private extension Angle {
    static let pi = Angle.degrees(180)
}

#if DEBUG
struct CalendarView_Previews : PreviewProvider {
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
