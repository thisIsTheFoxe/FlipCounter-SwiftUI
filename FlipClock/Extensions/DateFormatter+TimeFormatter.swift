import Foundation

extension DateFormatter {

    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmmss"
        return formatter
    }

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        return formatter
    }
}
