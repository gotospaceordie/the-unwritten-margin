import SwiftUI

/// The three destinations (Books, Inbox, Search) with Capture always available
/// in the bar above the tabs, within thumb reach.
struct RootView: View {
    @Environment(AppModel.self) private var model
    @State private var isCapturing = false

    var body: some View {
        TabView {
            Tab("Books", systemImage: "books.vertical") {
                BooksView()
            }
            Tab("Inbox", systemImage: "tray") {
                InboxView()
            }
            .badge(model.inboxCount)
            Tab(role: .search) {
                SearchView()
            }
        }
        .tabViewBottomAccessory {
            CaptureAccessory(bookTitle: model.currentBook?.title) {
                isCapturing = true
            }
        }
        .fullScreenCover(isPresented: $isCapturing) {
            CaptureView()
                .environment(model)
        }
    }
}

private struct CaptureAccessory: View {
    let bookTitle: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ViewThatFits(in: .horizontal) {
                label(showingBook: true)
                label(showingBook: false)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityShowsLargeContentViewer()
        .accessibilityLabel(bookTitle.map { "Capture a passage from \($0)" } ?? "Capture a passage")
        .accessibilityIdentifier("captureButton")
    }

    private func label(showingBook: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "camera.fill")
            Text("Capture")
                .fontWeight(.semibold)
            if showingBook, let bookTitle {
                Text("· \(bookTitle)")
                    .foregroundStyle(.secondary)
            }
        }
        .lineLimit(1)
        .fixedSize()
    }
}

#Preview {
    RootView()
        .environment(try! AppModel.sample())
}
