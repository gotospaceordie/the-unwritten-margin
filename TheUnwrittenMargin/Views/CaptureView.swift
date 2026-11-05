import SwiftUI

/// Capture opens straight into the passage editor for the current book's page.
/// The sample page stands in for the camera until #5 adds it.
struct CaptureView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            if let book = model.currentBook, let page = SampleContent.page(forBook: book.id) {
                PassageEditorView(
                    draft: PassageDraft(bookID: book.id, quotation: page.text),
                    mode: .capture
                ) {
                    dismiss()
                }
            } else {
                ContentUnavailableView(
                    "No book selected",
                    systemImage: "book.closed",
                    description: Text("Choose a book in Books first.")
                )
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
            }
        }
    }
}
