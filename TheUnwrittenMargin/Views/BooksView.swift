import SwiftUI

struct BooksView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        NavigationStack {
            List {
                if let current = model.currentBook {
                    Section("Reading now") {
                        NavigationLink(value: current.id) {
                            BookRow(book: current, passageCount: model.passages(for: current.id).count)
                        }
                    }
                }

                let others = model.books.filter { $0.id != model.currentBookID }
                if !others.isEmpty {
                    Section("Other books") {
                        ForEach(others) { book in
                            NavigationLink(value: book.id) {
                                BookRow(book: book, passageCount: model.passages(for: book.id).count)
                            }
                            .swipeActions(edge: .leading) {
                                Button("Make current") { model.makeCurrent(book) }
                                    .tint(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Books")
            .navigationDestination(for: BookEdition.ID.self) { bookID in
                BookDetailView(bookID: bookID)
            }
        }
    }
}

private struct BookRow: View {
    let book: BookEdition
    let passageCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
            Text(book.authors)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(passageCount == 1 ? "1 passage" : "\(passageCount) passages")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

struct BookDetailView: View {
    @Environment(AppModel.self) private var model
    let bookID: BookEdition.ID

    var body: some View {
        if let book = model.book(id: bookID) {
            let passages = model.passages(for: book.id)
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.authors)
                        Text(book.editionLabel ?? "Edition not recorded")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                }

                Section("Passages") {
                    if passages.isEmpty {
                        Text("No passages yet. Use Capture to save one.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(passages) { passage in
                            PassageRow(passage: passage)
                        }
                    }
                }
            }
            .navigationTitle(book.title)
            .safeAreaInset(edge: .bottom) {
                if model.currentBookID != book.id {
                    Button {
                        model.makeCurrent(book)
                    } label: {
                        Label("Make this the current book", systemImage: "bookmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding()
                }
            }
        } else {
            ContentUnavailableView("Book not found", systemImage: "book.closed")
        }
    }
}
