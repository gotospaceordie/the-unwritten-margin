import Foundation
import Testing
@testable import TheUnwrittenMargin

@MainActor
struct PageLabelTests {
    @Test(arguments: ["", "   ", "\n\t "])
    func blankInputIsUnknown(input: String) {
        #expect(PageLabel(userInput: input) == .unknown)
    }

    @Test(arguments: [("142", "142"), ("xiv", "xiv"), ("  37 ", "37"), ("unnumbered", "unnumbered")])
    func printedLabelsKeepTheirText(input: String, expected: String) {
        #expect(PageLabel(userInput: input) == .printed(expected))
    }
}

@MainActor
struct CaptureToSaveTests {
    let walden = SampleContent.walden
    let mobyDick = SampleContent.mobyDick

    private func makeModel(passages: (any PassageRepository)? = nil) throws -> AppModel {
        try AppModel(
            bookRepository: InMemoryBookRepository(books: SampleContent.books),
            passageRepository: passages ?? InMemoryPassageRepository(),
            now: { Date(timeIntervalSince1970: 1_800_000_000) }
        )
    }

    @Test func savingWithoutAPageLabelStoresTheLocationAsUnknown() throws {
        let model = try makeModel()

        let saved = try model.savePassage(PassageDraft(bookID: walden.id, quotation: "A sample sentence."))

        #expect(saved.pageLabel == .unknown)
        #expect(model.passagesWithUnknownPage.map(\.id) == [saved.id])
        #expect(model.inboxCount == 1)
    }

    @Test func aPassageWithoutAReflectionIsValid() throws {
        let model = try makeModel()
        var draft = PassageDraft(bookID: walden.id, quotation: "A sample sentence.")
        draft.pageInput = "12"
        draft.reflectionInput = "   \n"

        let saved = try model.savePassage(draft)

        #expect(saved.reflection == nil)
        #expect(model.passages(for: walden.id).map(\.id) == [saved.id])
    }

    @Test func quotationAndReflectionAreStoredSeparatelyAndUnchanged() throws {
        let model = try makeModel()
        let quotation = "  First line,\nsecond line—with a dash.  "
        var draft = PassageDraft(bookID: walden.id, quotation: quotation)
        draft.reflectionInput = "My own thought."

        let saved = try model.savePassage(draft)

        #expect(saved.quotation == quotation)
        #expect(saved.reflection == "My own thought.")
        #expect(!saved.quotation.contains("My own thought"))
    }

    @Test func savePhotoNowPutsAnIncompleteCaptureInTheInbox() throws {
        let model = try makeModel()
        let page = try #require(SampleContent.page(forBook: walden.id))

        let capture = try model.savePhotoNow(page)

        #expect(model.incompleteCaptures.map(\.id) == [capture.id])
        #expect(capture.bookID == walden.id)
        #expect(model.passages.isEmpty)
    }

    @Test func finishingAnIncompleteCaptureSavesThePassageAndClearsTheInboxItem() throws {
        let model = try makeModel()
        let page = try #require(SampleContent.page(forBook: walden.id))
        let capture = try model.savePhotoNow(page)
        var draft = PassageDraft(bookID: capture.bookID, quotation: page.text, completesCaptureID: capture.id)
        draft.pageInput = "90"

        try model.savePassage(draft)

        #expect(model.incompleteCaptures.isEmpty)
        #expect(model.passages(for: walden.id).map(\.quotation) == [page.text])
    }

    @Test func switchingTheCurrentBookLeavesSavedPassagesWithTheirBook() throws {
        let model = try makeModel()
        let saved = try model.savePassage(PassageDraft(bookID: walden.id, quotation: "A sample sentence."))

        model.makeCurrent(mobyDick)

        #expect(model.currentBook == mobyDick)
        #expect(model.passages(for: walden.id).map(\.id) == [saved.id])
        #expect(model.passages(for: mobyDick.id).isEmpty)
    }

    @Test func aFailedSaveStoresNothingAndThrows() throws {
        let model = try makeModel(passages: FailingPassageRepository())

        #expect(throws: FailingPassageRepository.WriteFailed.self) {
            try model.savePassage(PassageDraft(bookID: walden.id, quotation: "A sample sentence."))
        }
        #expect(model.passages.isEmpty)
    }

    @Test func aFailedSaveKeepsTheInboxItemItWasFinishing() throws {
        let repository = FailingPassageRepository()
        let model = try makeModel(passages: repository)
        let page = try #require(SampleContent.page(forBook: walden.id))
        let capture = try model.savePhotoNow(page)

        #expect(throws: FailingPassageRepository.WriteFailed.self) {
            try model.savePassage(PassageDraft(bookID: walden.id, quotation: page.text, completesCaptureID: capture.id))
        }
        #expect(model.incompleteCaptures.map(\.id) == [capture.id])
    }

    @Test func searchMatchesQuotationsAndReflectionsAndSaysWhere() throws {
        let model = try makeModel()
        var draft = PassageDraft(bookID: walden.id, quotation: "I went to the woods.")
        draft.reflectionInput = "Reminds me of a summer by the lake."
        try model.savePassage(draft)

        let byQuotation = model.search("WOODS")
        let byReflection = model.search("lake")

        #expect(byQuotation.count == 1)
        #expect(byQuotation.first?.matchesQuotation == true)
        #expect(byQuotation.first?.matchesReflection == false)
        #expect(byReflection.first?.matchesReflection == true)
        #expect(model.search("   ").isEmpty)
        #expect(model.search("whale").isEmpty)
    }
}

/// Saves Inbox captures but fails every passage write, like a full disk.
@MainActor
final class FailingPassageRepository: PassageRepository {
    struct WriteFailed: Error {}

    private let inner = InMemoryPassageRepository()

    func allPassages() throws -> [Passage] { inner.allPassages() }
    func save(_ passage: Passage) throws { throw WriteFailed() }
    func allIncompleteCaptures() throws -> [IncompleteCapture] { inner.allIncompleteCaptures() }
    func save(_ capture: IncompleteCapture) throws { inner.save(capture) }
    func removeIncompleteCapture(id: IncompleteCapture.ID) throws { inner.removeIncompleteCapture(id: id) }
}
