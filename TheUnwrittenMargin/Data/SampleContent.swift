import Foundation

/// Prototype content. Every book here is in the public domain, and each text is
/// a short, exact quotation from it. Edition details and page numbers are not
/// invented: editions read "Sample edition" and pages start unknown.
enum SampleContent {
    static let walden = BookEdition(
        id: UUID(uuidString: "6F1C2B0A-3E4D-4C5B-9A1F-000000000001")!,
        title: "Walden",
        authors: "Henry David Thoreau",
        editionLabel: "Sample edition"
    )

    static let prideAndPrejudice = BookEdition(
        id: UUID(uuidString: "6F1C2B0A-3E4D-4C5B-9A1F-000000000002")!,
        title: "Pride and Prejudice",
        authors: "Jane Austen",
        editionLabel: "Sample edition"
    )

    static let mobyDick = BookEdition(
        id: UUID(uuidString: "6F1C2B0A-3E4D-4C5B-9A1F-000000000003")!,
        title: "Moby-Dick",
        authors: "Herman Melville",
        editionLabel: "Sample edition"
    )

    static let books = [walden, prideAndPrejudice, mobyDick]

    static let pages = [
        SamplePage(
            id: UUID(uuidString: "6F1C2B0A-3E4D-4C5B-9A1F-000000000101")!,
            bookID: walden.id,
            text: "I went to the woods because I wished to live deliberately, to front only the essential facts of life, and see if I could not learn what it had to teach, and not, when I came to die, discover that I had not lived."
        ),
        SamplePage(
            id: UUID(uuidString: "6F1C2B0A-3E4D-4C5B-9A1F-000000000102")!,
            bookID: prideAndPrejudice.id,
            text: "It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife."
        ),
        SamplePage(
            id: UUID(uuidString: "6F1C2B0A-3E4D-4C5B-9A1F-000000000103")!,
            bookID: mobyDick.id,
            text: "Call me Ishmael. Some years ago—never mind how long precisely—having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world."
        ),
    ]

    static func page(forBook bookID: BookEdition.ID) -> SamplePage? {
        pages.first { $0.bookID == bookID }
    }

    static func page(id: SamplePage.ID) -> SamplePage? {
        pages.first { $0.id == id }
    }
}
