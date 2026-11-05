import Foundation

/// One physical edition of a book. Page 142 in one edition can be a different
/// passage in another, so passages belong to an edition, not to a title.
struct BookEdition: Identifiable, Hashable, Sendable {
    let id: UUID
    var title: String
    var authors: String
    /// Free text such as "Penguin Classics, 2003". `nil` means not recorded.
    var editionLabel: String?
}
