import Foundation

/// Where a passage sits in the printed book.
///
/// Labels are strings ("142", "xiv", "unnumbered") because printed page labels
/// aren't always numbers. A blank entry is stored as `.unknown`; the app never
/// infers a page number.
enum PageLabel: Hashable, Sendable {
    case unknown
    case printed(String)

    init(userInput: String) {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        self = trimmed.isEmpty ? .unknown : .printed(trimmed)
    }

    var isUnknown: Bool { self == .unknown }

    var displayText: String {
        switch self {
        case .unknown: "Page unknown"
        case .printed(let label): "Page \(label)"
        }
    }
}
