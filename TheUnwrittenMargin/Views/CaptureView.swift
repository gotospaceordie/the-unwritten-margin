import SwiftUI

/// Shows the current book and a page to capture. The sample page stands in for
/// the camera until #5 adds it.
struct CaptureView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var draft: PassageDraft?
    @State private var savedMessage: String?
    @State private var isShowingSaveError = false

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Capture")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { dismiss() }
                    }
                }
                .navigationDestination(item: $draft) { draft in
                    PassageEditorView(draft: draft) { dismiss() }
                }
        }
        .overlay {
            if let savedMessage {
                SavedBanner(message: savedMessage)
            }
        }
        .alert("Couldn't save", isPresented: $isShowingSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The page was not saved. Try again, or use this page now.")
        }
    }

    @ViewBuilder
    private var content: some View {
        if let book = model.currentBook, let page = SampleContent.page(forBook: book.id) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CurrentBookPicker(book: book)
                    SamplePageView(text: page.text)
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    Button {
                        draft = PassageDraft(bookID: book.id, quotation: page.text)
                    } label: {
                        Label("Use this page", systemImage: "text.viewfinder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityHint("Opens the passage editor with this page's text")
                    .accessibilityIdentifier("useThisPage")

                    Button {
                        savePhotoNow(page, book: book)
                    } label: {
                        Label("Save photo now", systemImage: "tray.and.arrow.down")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityHint("Keeps this page in the Inbox to finish later")
                    .accessibilityIdentifier("savePhotoNow")
                }
                .controlSize(.large)
                .disabled(savedMessage != nil)
                .padding()
                .background(.bar)
            }
        } else {
            ContentUnavailableView(
                "No book selected",
                systemImage: "book.closed",
                description: Text("Choose a book in Books first.")
            )
        }
    }

    private func savePhotoNow(_ page: SamplePage, book: BookEdition) {
        do {
            try model.savePhotoNow(page)
            let message = "Saved to Inbox"
            AccessibilityNotification.Announcement(message).post()
            withAnimation { savedMessage = message }
            Task {
                try? await Task.sleep(for: .seconds(1))
                dismiss()
            }
        } catch {
            isShowingSaveError = true
        }
    }
}

private struct CurrentBookPicker: View {
    @Environment(AppModel.self) private var model
    let book: BookEdition

    var body: some View {
        @Bindable var model = model
        VStack(alignment: .leading, spacing: 6) {
            Text("Capturing from")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Menu {
                Picker("Book", selection: $model.currentBookID) {
                    ForEach(model.books) { book in
                        Text(book.title).tag(Optional(book.id))
                    }
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.title)
                            .font(.title2.bold())
                        Text(book.authors)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.tint)
                }
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
            }
            .accessibilityLabel("Book: \(book.title) by \(book.authors)")
            .accessibilityHint("Double-tap to choose a different book")
        }
    }
}

private struct SamplePageView: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Sample page, standing in for the camera", systemImage: "photo")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(text)
                .fontDesign(.serif)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 12))
        }
        .accessibilityElement(children: .combine)
    }
}
