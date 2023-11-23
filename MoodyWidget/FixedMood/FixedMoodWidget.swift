//
//  FixedMoodWidget.swift
//  MoodyApp
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import WidgetKit
import SwiftUI

struct FixedMoodProvider: IntentTimelineProvider {
    typealias Entry = FixedMoodEntry
    typealias Intent = FixedMoodIntent
    
    func placeholder(in context: Context) -> FixedMoodEntry {
        FixedMoodEntry(date: Date(), imageName: "mood1")
    }
    
    func getSnapshot(for configuration: FixedMoodIntent, in context: Context, completion: @escaping (FixedMoodEntry) -> Void) {
        completion(FixedMoodEntry(date: Date(), imageName: "mood1"))
    }
    
    func getTimeline(for configuration: FixedMoodIntent, in context: Context, completion: @escaping (Timeline<FixedMoodEntry>) -> Void) {
        var entries: [Entry] = []
        
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 5, to: currentDate)!
        
        // Create a single entry with the selected mood
        let index = configuration.userMood.rawValue
        let imageName = images[index].imageName
        let entry = Entry(date: currentDate, imageName: imageName)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
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
        IntentConfiguration(kind: kind,
                            intent: FixedMoodIntent.self, 
                            provider: FixedMoodProvider()) { entry in
            if #available(iOS 17.0, *) {
                FixedMoodWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                FixedMoodWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Fixed Mood Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    FixedMoodWidget()
} timeline: {
    FixedMoodEntry(date: .now, imageName: "mood2")
}
