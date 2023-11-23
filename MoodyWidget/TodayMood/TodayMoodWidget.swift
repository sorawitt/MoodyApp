//
//  MoodyWidget.swift
//  MoodyWidget
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import WidgetKit
import SwiftUI

struct TodayMoodProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayMoodEntry {
        TodayMoodEntry(date: Date(), imageName: "mood1")
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayMoodEntry) -> ()) {
        let entry = TodayMoodEntry(date: Date(), imageName: "mood1")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TodayMoodEntry] = []

        // Update the timeline every 5 seconds
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 6, to: currentDate)!
        
        for offset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: offset, to: currentDate)!
            let entry = TodayMoodEntry(date: entryDate, imageName: "mood\(offset + 1)")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct TodayMoodEntry: TimelineEntry {
    let date: Date
    let imageName: String
}

struct TodayMoodWidgetEntryView : View {
    var entry: TodayMoodProvider.Entry
    
    var body: some View {
        if let selectedImageName = UserDefaults(suiteName: "group.com.sorawitt.moodyAppExtension")?.string(forKey: "selectedImageName") {
            Image(selectedImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text("No image selected")
                .padding()
        }
    }
}

struct TodayMoodWidget: Widget {
    let kind: String = "TodayMoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayMoodProvider()) { entry in
            if #available(iOS 17.0, *) {
                TodayMoodWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodayMoodWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    TodayMoodWidget()
} timeline: {
    TodayMoodEntry(date: .now, imageName: "mood2")
}
