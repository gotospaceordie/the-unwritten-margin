import SwiftUI

/// Confirms the book, shows the author's words, and takes an optional page
/// label and reflection. Save sits at the bottom, within thumb reach, and stays
/// above the keyboard.
struct PassageEditorView: View {
    @Environment(AppModel.self) private var model
    @State private var draft: PassageDraft
    @State private var savedMessage: String?
    @State private var isShowingSaveError = false
    let onFinished: () -> Void

    init(draft: PassageDraft, onFinished: @escaping () -> Void) {
        _draft = State(initialValue: draft)
        self.onFinished = onFinished
    }

    var body: some View {
        Form {
            if let book = model.book(id: draft.bookID) {
                Section("Book") {
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

            Section {
                QuotationText(draft.quotation)
            } header: {
                Text("From the book")
            } footer: {
                Text("Sample text, not recognised from a photo.")
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
        }
        .navigationTitle("Passage")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button(action: save) {
                Label("Save passage", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(savedMessage != nil)
            .accessibilityIdentifier("savePassage")
            .padding()
            .background(.bar)
        }
        .overlay {
            if let savedMessage {
                SavedBanner(message: savedMessage)
            }
        }
        .alert("Couldn't save", isPresented: $isShowingSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your passage was not saved. Everything you typed is still here, so you can try again.")
        }
    }

    private func save() {
        do {
            try model.savePassage(draft)
            let title = model.book(id: draft.bookID)?.title
            let message = title.map { "Saved to \($0)" } ?? "Saved"
            AccessibilityNotification.Announcement(message).post()
            withAnimation { savedMessage = message }
            Task {
                try? await Task.sleep(for: .seconds(1))
                onFinished()
            }
        } catch {
            isShowingSaveError = true
        }
    }
}
