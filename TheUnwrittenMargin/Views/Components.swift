import SwiftUI

/// The author's words: serif, with a bar on the leading edge, so they never look
/// like the reader's reflection.
struct QuotationText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .fontDesign(.serif)
            .padding(.leading, 12)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(.tint)
                    .frame(width: 3)
            }
            .accessibilityLabel("Quotation: \(text)")
    }
}

struct PassageRow: View {
    let passage: Passage
    var bookTitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let bookTitle {
                Text(bookTitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            QuotationText(passage.quotation)
                .lineLimit(4)
            Text(passage.pageLabel.displayText)
                .font(.caption)
                .foregroundStyle(passage.pageLabel.isUnknown ? Color.orange : Color.secondary)
            if let reflection = passage.reflection {
                VStack(alignment: .leading, spacing: 2) {
                    Text("My reflection")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(reflection)
                        .lineLimit(3)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.vertical, 4)
    }
}

/// Shown only after a save has actually succeeded.
struct SavedBanner: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "checkmark.circle.fill")
            .font(.headline)
            .padding()
            .background(.regularMaterial, in: .capsule)
            .transition(.scale.combined(with: .opacity))
    }
}
