import Foundation
import Observation

/// App-wide state shared by every screen: the books, the current book, and what
/// has been saved. Views read it from the SwiftUI environment and redraw when
/// it changes.
@Observable
final class AppModel {
    private let bookRepository: any BookRepository
    private let passageRepository: any PassageRepository
    private let now: () -> Date

    private(set) var books: [BookEdition] = []
    private(set) var passages: [Passage] = []
    private(set) var incompleteCaptures: [IncompleteCapture] = []
    var currentBookID: BookEdition.ID?

    init(
        bookRepository: any BookRepository,
        passageRepository: any PassageRepository,
        now: @escaping () -> Date = Date.init
    ) throws {
        self.bookRepository = bookRepository
        self.passageRepository = passageRepository
        self.now = now
        try reload()
        currentBookID = books.first?.id
    }

    static func sample() throws -> AppModel {
        try AppModel(
            bookRepository: InMemoryBookRepository(books: SampleContent.books),
            passageRepository: InMemoryPassageRepository()
        )
    }

    var currentBook: BookEdition? {
        currentBookID.flatMap(book(id:))
    }

    func book(id: BookEdition.ID) -> BookEdition? {
        books.first { $0.id == id }
    }

    func makeCurrent(_ book: BookEdition) {
        currentBookID = book.id
    }

    func passages(for bookID: BookEdition.ID) -> [Passage] {
        passages
            .filter { $0.bookID == bookID }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var passagesWithUnknownPage: [Passage] {
        passages
            .filter(\.pageLabel.isUnknown)
            .sorted { $0.createdAt > $1.createdAt }
    }

    var inboxCount: Int {
        incompleteCaptures.count + passagesWithUnknownPage.count
    }

    /// Saves the draft as a new passage. Throws if storage fails, in which case
    /// nothing is shown as saved and any Inbox item the draft finishes stays put.
    @discardableResult
    func savePassage(_ draft: PassageDraft) throws -> Passage {
        let passage = draft.makePassage(createdAt: now())
        try passageRepository.save(passage)
        if let captureID = draft.completesCaptureID {
            try passageRepository.removeIncompleteCapture(id: captureID)
        }
        try reload()
        return passage
    }

    /// The quick path: keep the page and its book now, finish it later from the Inbox.
    @discardableResult
    func savePhotoNow(_ page: SamplePage) throws -> IncompleteCapture {
        let capture = IncompleteCapture(id: UUID(), bookID: page.bookID, pageID: page.id, createdAt: now())
        try passageRepository.save(capture)
        try reload()
        return capture
    }

    func search(_ query: String) -> [SearchResult] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return [] }
        return passages
            .sorted { $0.createdAt > $1.createdAt }
            .compactMap { passage in
                let inQuotation = passage.quotation.localizedStandardContains(query)
                let inReflection = passage.reflection?.localizedStandardContains(query) ?? false
                guard inQuotation || inReflection else { return nil }
                return SearchResult(passage: passage, matchesQuotation: inQuotation, matchesReflection: inReflection)
            }
    }

    private func reload() throws {
        books = try bookRepository.allBooks()
        passages = try passageRepository.allPassages()
        incompleteCaptures = try passageRepository.allIncompleteCaptures()
            .sorted { $0.createdAt > $1.createdAt }
    }
}

struct SearchResult: Identifiable {
    let passage: Passage
    let matchesQuotation: Bool
    let matchesReflection: Bool

    var id: Passage.ID { passage.id }

    var matchDescription: String {
        switch (matchesQuotation, matchesReflection) {
        case (true, true): "Found in the quotation and your reflection"
        case (false, true): "Found in your reflection"
        default: "Found in the quotation"
        }
    }
}
