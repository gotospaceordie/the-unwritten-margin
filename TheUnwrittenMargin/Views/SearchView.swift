import SwiftUI

/// Prototype keyword search over this session's passages. #8 replaces it with
/// search over stored passages.
struct SearchView: View {
    @Environment(AppModel.self) private var model
    @State private var query = ""

    var body: some View {
        NavigationStack {
            let results = model.search(query)
            List(results) { result in
                VStack(alignment: .leading, spacing: 4) {
                    PassageRow(passage: result.passage, bookTitle: model.book(id: result.passage.bookID)?.title)
                    Text(result.matchDescription)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay {
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView(
                        "Search your passages",
                        systemImage: "magnifyingglass",
                        description: Text("Finds words in quotations and in your reflections saved this session.")
                    )
                } else if results.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $query, prompt: "Quotations and reflections")
        }
    }
}
