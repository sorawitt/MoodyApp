//
//  FixedMoodWidget.swift
//  MoodyApp
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import WidgetKit
import SwiftUI

struct FixedMoodProvider: TimelineProvider {
    func placeholder(in context: Context) -> FixedMoodEntry {
        FixedMoodEntry(date: Date(), imageName: "mood1")
    }

    func getSnapshot(in context: Context, completion: @escaping (FixedMoodEntry) -> ()) {
        let entry = FixedMoodEntry(date: Date(), imageName: "mood1")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    }
}

struct FixedMoodEntry: TimelineEntry {
    let date: Date
    let imageName: String
}

struct FixedMoodWidgetEntryView : View {
    var entry: FixedMoodProvider.Entry
    
    var body: some View {
        let imageName = entry.imageName
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FixedMoodWidget: Widget {
    let kind: String = "FixedMoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FixedMoodProvider()) { entry in
            if #available(iOS 17.0, *) {
                FixedMoodWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                FixedMoodWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    FixedMoodWidget()
} timeline: {
    FixedMoodEntry(date: .now, imageName: "mood2")
}
