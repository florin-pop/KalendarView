//
//  DayView.swift
//  
//
//  Created by Florin Pop on 08.07.20.
//

import SwiftUI

struct DayView: View {
    let date: Date
    
    var textColor: Color {
        self.date.isToday() ? .todayForeground : .textForeground
    }
    
    var backgroundColor: Color {
        self.date.isToday() ?  .todayBackground : .textBackground
    }
    
    var body: some View {
        Text(date.formatDayOfMonth())
            .foregroundColor(textColor)
            .fitWidthInCalendarCell()
            .background(backgroundColor)
            .cornerRadius(.cellWidth / 2)
            .fitWidthInCalendarCell()
            .fitHeightInCalendarCell()
    }
}

#if DEBUG
struct DayView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            DayView(date: Date().addingTimeInterval(60*60*24*365))
                .previewDisplayName("Control")
            DayView(date: Date())
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
