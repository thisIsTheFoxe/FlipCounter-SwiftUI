//
//  FCWidget.swift
//  FCWidget
//
//  Created by Henrik Storch on 15.09.22.
//  Copyright © 2022 Maciej Gomółka. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = [SimpleEntry(date: .now)]
        let nextMidnight = Calendar.current.startOfDay(for: .now).addingTimeInterval(60*60*24)
        entries.append(SimpleEntry(date: nextMidnight))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry
    let model = CounterViewModel()
    var digits: Int { model.digits }
    @Environment(\.widgetFamily) var family


    var body: some View {
        VStack(spacing: family == .accessoryRectangular || family == .systemSmall ? 0 : 8) {
            if family == .accessoryRectangular {
                Spacer()
            }
            Text(model.description)
                .font(family == .accessoryRectangular ? .caption : .body)
            HStack {
                Spacer()
                ForEach(0..<digits, id: \.self) { id in
                    let ix = digits - id - 1
                    let digitAtIx = (model.daysSince / Int(pow(Double(model.base.rawValue), Double(ix)))) % model.base.rawValue
                    SimpleFlipView(text: model.base.character(for: digitAtIx))
                }
                Spacer()
            }.scaleEffect(family == .systemSmall || family == .accessoryRectangular ? 0.5 : 1)
        }
    }
}

@main
struct CounterWidget: Widget {
    let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Counter")
        .description("lil counter widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryRectangular])
    }
}

struct FCWidget_Previews: PreviewProvider {
    static var previews: some View {
        CounterWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
