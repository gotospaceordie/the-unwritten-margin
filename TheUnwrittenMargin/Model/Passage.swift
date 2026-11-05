import Foundation

/// A saved quotation from a book, with its location and the reader's reflection.
struct Passage: Identifiable, Hashable, Sendable {
    let id: UUID
    let bookID: BookEdition.ID
    /// The author's words, exactly as saved. Never trimmed or rewritten.
    let quotation: String
    var pageLabel: PageLabel
    /// The reader's own words; `nil` when the passage was saved without one.
    var reflection: String?
    let createdAt: Date
}

/// A page kept with "Finish later", waiting in the Inbox to be finished.
struct IncompleteCapture: Identifiable, Hashable, Sendable {
    let id: UUID
    let bookID: BookEdition.ID
    let pageID: SamplePage.ID
    let createdAt: Date
}

/// What the passage editor is working on before it is saved.
struct PassageDraft: Hashable, Sendable {
    var bookID: BookEdition.ID
    var quotation: String
    var pageInput = ""
    var reflectionInput = ""
    /// Set when the draft finishes an Inbox item, which is removed once the passage saves.
    var completesCaptureID: IncompleteCapture.ID?

    /// True once the reader has typed a page label or a reflection.
    var hasReaderInput: Bool {
        !pageInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !reflectionInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Moves the draft to another book's page. The reader's page label and
    /// reflection are kept: changing the book never discards notes.
    mutating func switchBook(to page: SamplePage) {
        bookID = page.bookID
        quotation = page.text
    }

    func makePassage(id: UUID = UUID(), createdAt: Date) -> Passage {
        let hasReflection = !reflectionInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return Passage(
            id: id,
            bookID: bookID,
            quotation: quotation,
            pageLabel: PageLabel(userInput: pageInput),
            reflection: hasReflection ? reflectionInput : nil,
            createdAt: createdAt
        )
    }
}

/// Stands in for a photographed page until the camera and OCR exist.
struct SamplePage: Identifiable, Hashable, Sendable {
    let id: UUID
    let bookID: BookEdition.ID
    let text: String
}
