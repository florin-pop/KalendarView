//
//  ContentView.swift
//  KalendarViewExample
//
//  Created by Florin Pop on 09.07.20.
//  Copyright © 2020 Florin Pop. All rights reserved.
//

import SwiftUI
import KalendarView

struct ContentView: View {
    @ObservedObject var selection = KalendarSelection()
    @State var fromDate: Date = Date().addingTimeInterval(-60*60*24*365)
    @State var toDate: Date = Date().addingTimeInterval(60*60*24*14*5)
    
    var body: some View {
        VStack(alignment: .center, spacing: .none) {
            KalendarView(fromDate: fromDate, toDate: toDate, scrollToBottom: true, selection: self.selection) { date in
                
                if Calendar.current.isDate(date, equalTo: Date().addingTimeInterval(60*60*24*14), toGranularity: .day) {
                    Image(systemName: "bell")
                        .frame(width: 5, height: 5)
                }
            }
            Text(getTextFromDate(date: self.selection.date))
        }
    }
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "No Selection" : "Selection: " + formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
