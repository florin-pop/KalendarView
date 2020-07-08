//
//  KalendarTitleView.swift
//  
//
//  Created by Florin Pop on 08.07.20.
//

import SwiftUI

struct KalendarTitleView : View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).padding()
            HStack(alignment: .bottom) {
                ForEach(DateFormatter.weekdaySymbols, id: \.self) { weekday in
                    HStack {
                        Spacer()
                        Text(weekday).fitWidthInCalendarCell()
                        Spacer()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct KalendarTitleView_Previews : PreviewProvider {
    static var previews: some View {
        KalendarTitleView(title: .constant("May 2020"))
    }
}
#endif
