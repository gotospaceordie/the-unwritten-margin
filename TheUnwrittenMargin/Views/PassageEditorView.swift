import SwiftUI

/// One screen from page to saved passage: confirm the book, see the author's
/// words, add an optional page label and reflection, then save. Save sits at
/// the bottom within thumb reach and stays above the keyboard. Cancel asks
/// before throwing away anything the reader typed.
struct PassageEditorView: View {
    enum Mode {
        /// A new capture: the book can be changed, and the page can be kept for later.
        case capture
        /// Finishing a page saved earlier with "Finish later".
        case finishing
    }

    @Environment(AppModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var draft: PassageDraft
    @State private var savedMessage: String?
    @State private var isShowingSaveError = false
    @State private var isConfirmingDiscard = false
    let mode: Mode
    let onFinished: () -> Void

    init(draft: PassageDraft, mode: Mode, onFinished: @escaping () -> Void) {
        _draft = State(initialValue: draft)
        self.mode = mode
        self.onFinished = onFinished
    }

    var body: some View {
        Form {
            if let book = model.book(id: draft.bookID) {
                Section("Book") {
                    switch mode {
                    case .capture: bookPicker(current: book)
                    case .finishing: BookSummary(book: book)
                    }
                }
            }

            Section {
                QuotationText(draft.quotation)
            } header: {
                Text("From the page")
            } footer: {
                Text("Sample text standing in for a photo. It wasn't recognised from a real page.")
            }

            Section {
                TextField("Page", text: $draft.pageInput, prompt: Text("Unknown"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Page label")
                    .accessibilityHint("Optional. Leave blank if the page number isn't visible.")
                    .accessibilityIdentifier("pageLabelField")
            } header: {
                Text("Page")
            } footer: {
                Text("Leave blank if there's no page number. It will be saved as unknown.")
            }

            Section("My reflection") {
                TextField("Your thoughts (optional)", text: $draft.reflectionInput, axis: .vertical)
                    .lineLimit(4...)
                    .accessibilityLabel("My reflection")
                    .accessibilityHint("Optional. Type, or use the keyboard's dictation button.")
                    .accessibilityIdentifier("reflectionField")
            }

            // At accessibility text sizes the pinned bar would cover most of the
            // screen, so Finish later moves into the form and only Save stays pinned.
            if mode == .capture && dynamicTypeSize.isAccessibilitySize {
                Section {
                    finishLaterButton
                } footer: {
                    finishLaterExplanation
                }
            }
        }
        .navigationTitle(mode == .capture ? "New passage" : "Finish passage")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: cancel)
                    .accessibilityIdentifier("cancelPassage")
            }
        }
        .interactiveDismissDisabled(draft.hasReaderInput)
        .safeAreaInset(edge: .bottom) { actions }
        .overlay {
            if let savedMessage {
                SavedBanner(message: savedMessage)
            }
        }
        .alert("Discard this passage?", isPresented: $isConfirmingDiscard) {
            Button("Discard", role: .destructive, action: onFinished)
            Button("Keep editing", role: .cancel) {}
        } message: {
            Text("Your page label and reflection haven't been saved.")
        }
        .alert("Couldn't save", isPresented: $isShowingSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Nothing was saved. Everything you typed is still here, so you can try again.")
        }
    }

    private var actions: some View {
        VStack(spacing: 8) {
            Button(action: save) {
                Label("Save passage", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("savePassage")

            if mode == .capture && !dynamicTypeSize.isAccessibilitySize {
                finishLaterButton
                finishLaterExplanation
                    .multilineTextAlignment(.center)
            }
        }
        .controlSize(.large)
        .disabled(savedMessage != nil)
        .padding()
        .background(.bar)
    }

    private var finishLaterButton: some View {
        Button(action: finishLater) {
            Label("Finish later", systemImage: "tray.and.arrow.down")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .disabled(savedMessage != nil)
        .accessibilityHint("Keeps this page and book in the Inbox to finish later")
        .accessibilityIdentifier("finishLater")
    }

    private var finishLaterExplanation: some View {
        Text("Keeps the page in your Inbox. Add the page and your thoughts when you have time.")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }

    private func bookPicker(current book: BookEdition) -> some View {
        Menu {
            ForEach(model.books) { candidate in
                Button {
                    switchBook(to: candidate)
                } label: {
                    if candidate.id == book.id {
                        Label(candidate.title, systemImage: "checkmark")
                    } else {
                        Text(candidate.title)
                    }
                }
            }
        } label: {
            HStack {
                BookSummary(book: book)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundStyle(.tint)
            }
            .foregroundStyle(.primary)
        }
        .accessibilityLabel("Book: \(book.title) by \(book.authors)")
        .accessibilityHint("Double-tap to choose a different book")
        .accessibilityIdentifier("bookPicker")
    }

    private func switchBook(to book: BookEdition) {
        guard let page = SampleContent.page(forBook: book.id) else { return }
        draft.switchBook(to: page)
        model.makeCurrent(book)
    }

    private func cancel() {
        if draft.hasReaderInput {
            isConfirmingDiscard = true
        } else {
            onFinished()
        }
    }

    private func save() {
        do {
            try model.savePassage(draft)
            let title = model.book(id: draft.bookID)?.title
            confirmAndFinish(title.map { "Saved to \($0)" } ?? "Saved")
        } catch {
            isShowingSaveError = true
        }
    }

    private func finishLater() {
        guard let page = SampleContent.page(forBook: draft.bookID) else { return }
        do {
            try model.keepForLater(page)
            confirmAndFinish("Kept in Inbox")
        } catch {
            isShowingSaveError = true
        }
    }

    /// Only called after a write has succeeded.
    private func confirmAndFinish(_ message: String) {
        AccessibilityNotification.Announcement(message).post()
        withAnimation { savedMessage = message }
        Task {
            try? await Task.sleep(for: .seconds(1))
            onFinished()
        }
    }
}

private struct BookSummary: View {
    let book: BookEdition

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(book.title)
                .font(.headline)
            Text(book.authors)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}
