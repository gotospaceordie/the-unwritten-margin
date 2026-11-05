import SwiftUI

/// Things to finish later: pages kept with "Finish later" and passages
/// saved without a page label.
struct InboxView: View {
    @Environment(AppModel.self) private var model
    @State private var path: [IncompleteCapture] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !model.incompleteCaptures.isEmpty {
                    Section {
                        ForEach(model.incompleteCaptures) { capture in
                            NavigationLink(value: capture) {
                                IncompleteCaptureRow(
                                    bookTitle: model.book(id: capture.bookID)?.title ?? "Unknown book",
                                    createdAt: capture.createdAt
                                )
                            }
                        }
                    } header: {
                        Text("Photos to finish")
                    } footer: {
                        Text("Kept with Finish later. Add the page and your thoughts when you have a moment.")
                    }
                }

                if !model.passagesWithUnknownPage.isEmpty {
                    Section("Page unknown") {
                        ForEach(model.passagesWithUnknownPage) { passage in
                            PassageRow(passage: passage, bookTitle: model.book(id: passage.bookID)?.title)
                        }
                    }
                }
            }
            .overlay {
                if model.inboxCount == 0 {
                    ContentUnavailableView(
                        "Inbox is empty",
                        systemImage: "tray",
                        description: Text("Photos saved for later and passages without a page show up here.")
                    )
                }
            }
            .navigationTitle("Inbox")
            .navigationDestination(for: IncompleteCapture.self) { capture in
                if let page = SampleContent.page(id: capture.pageID) {
                    PassageEditorView(
                        draft: PassageDraft(bookID: capture.bookID, quotation: page.text, completesCaptureID: capture.id),
                        mode: .finishing
                    ) {
                        path.removeAll()
                    }
                } else {
                    ContentUnavailableView("Page not found", systemImage: "photo")
                }
            }
        }
    }
}

private struct IncompleteCaptureRow: View {
    let bookTitle: String
    let createdAt: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(bookTitle)
                .font(.headline)
            Text("Saved \(createdAt, format: .relative(presentation: .named))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens the passage editor to finish this capture")
    }
}
