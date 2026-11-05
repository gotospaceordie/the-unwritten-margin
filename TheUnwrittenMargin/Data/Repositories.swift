import Foundation

/// Where books come from. The prototype uses `InMemoryBookRepository`; #4 adds
/// a SwiftData-backed one behind the same protocol.
protocol BookRepository {
    func allBooks() throws -> [BookEdition]
}

/// Where passages and unfinished captures are stored. Every write can fail, and
/// callers must only report "Saved" after a write returns without throwing.
protocol PassageRepository {
    func allPassages() throws -> [Passage]
    func save(_ passage: Passage) throws
    func allIncompleteCaptures() throws -> [IncompleteCapture]
    func save(_ capture: IncompleteCapture) throws
    func removeIncompleteCapture(id: IncompleteCapture.ID) throws
}

final class InMemoryBookRepository: BookRepository {
    private let books: [BookEdition]

    init(books: [BookEdition]) {
        self.books = books
    }

    func allBooks() -> [BookEdition] {
        books
    }
}

/// Keeps everything in memory, so it is gone when the app quits.
final class InMemoryPassageRepository: PassageRepository {
    private var passages: [Passage] = []
    private var captures: [IncompleteCapture] = []

    func allPassages() -> [Passage] {
        passages
    }

    func save(_ passage: Passage) {
        if let index = passages.firstIndex(where: { $0.id == passage.id }) {
            passages[index] = passage
        } else {
            passages.append(passage)
        }
    }

    func allIncompleteCaptures() -> [IncompleteCapture] {
        captures
    }

    func save(_ capture: IncompleteCapture) {
        captures.append(capture)
    }

    func removeIncompleteCapture(id: IncompleteCapture.ID) {
        captures.removeAll { $0.id == id }
    }
}
