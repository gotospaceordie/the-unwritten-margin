# The Unwritten Margin — App Blueprint

Prepared October 17, 2026 • Updated October 23, 2026 • Product and implementation brief version 1.1

## 0 Product name, development identifiers, and brand direction (agreed October 23, 2026)

### Selected product identity

**Official working product name:** The Unwritten Margin

The name captures the app’s founding idea: preserve reflections and annotations on physical books without marking their pages. We considered shorter forms (including Unmargin), but chose the full poetic name deliberately, favoring its literary appeal over one-word brevity. Retain this name across product planning and development unless future clearance findings require a change.

### Development naming conventions

| Use | Agreed name / value |
| --- | --- |
| Public-facing product name | **The Unwritten Margin** |
| Local project folder | `TheUnwrittenMargin` |
| GitHub repository | `the-unwritten-margin` |
| Internal application/project identifier | `TheUnwrittenMargin` |

An eventual iOS bundle identifier must use a unique reverse-DNS identifier under a domain controlled by the developer; **none was selected yet**. Display name, App Store subtitle, icon, and domain also remain to be finalized.

### Brand and marketing language

**Brand title:** The Unwritten Margin

**Poetic line (preferred):** “A place for the thoughts you leave between the lines.”

**Positioning statement:** “A reading companion for people who love their books too much to write in them.”

**Core promise / brand philosophy:** The book remains untouched; the reader’s passages, observations, and ideas remain theirs to preserve and revisit.

**Market narrative:** A private, searchable home for photographed book passages, digital underlines and highlights, dictated or typed reflections, and eventually connections among ideas and material for blog posts. It should feel literary rather than like a generic note utility.

### Intended release approach

- Initially build for personal use and verify the core capture-to-reflection workflow.
- Aim to make the app available to other readers on the Apple App Store, **free at first**.
- Keep reliable core reading-capture functions useful without a paid subscription; possible future AI enhancements or paid tiers are exploratory, not commitments.
- Before public release, verify App Store name availability, trademark clearance, domains, and related brand conflicts. The current name is a **product decision**, not a claim of legal or marketplace availability.

---

## 1 Purpose and proposed direction

Create a private iPhone reading companion that lets Paul annotate physical books without marking them. Photograph a passage, select the exact words, dictate a reflection, and save everything with its book, edition, and page. Over time, the collection becomes a searchable reading journal and source material for blog writing.

The governing principle is simple: capturing a thought should interrupt reading as little as possible. Organizing and polishing can happen later. The app should remain useful without generative AI or a subscription service.

This is a proposed build specification, not implemented software. Defaults below are recommendations that can be changed after a short prototype trial. Agreed product name: **The Unwritten Margin** (October 23, 2026). App Store naming, domain, and trademark availability still require verification before public release.

## 2 Product assumptions

- Start with one reader, physical books, English text, and an iPhone.
- Make capture, OCR, editing, and local search work without an account or network connection. Voice transcription has a separate device and language capability check.
- Use an uncluttered, readable interface with large type, Dynamic Type, VoiceOver, dark mode, and controls usable while holding a book.
- Keep original images and original transcription evidence until the reader chooses to remove them.
- Store the author's words, the reader's words, and AI output in distinct fields and visibly distinct areas.
- Support multiple books in progress. Remember the most recently used book but always show its identity before saving.
- Treat edition information as essential context: page 142 in one edition can be a different passage in another.
- Start with a native iPhone app. Add sync and larger-screen use after the capture loop works well.

## 3 The main reading experience

1. Open the app to a large Capture button and the current book.
2. Photograph one page or import an existing image. Preserve the source image; allow rotation and a separate crop.
3. Extract text locally. Select a sentence or paragraph in readable extracted text; optionally underline or highlight part of the selected excerpt.
4. Suggest the printed page label only when visible. Let the reader enter it, correct it, or mark it unknown. Never infer a page number from the photograph count.
5. Tap Add reflection and dictate or type. A passage without a reflection is also valid.
6. Save immediately. Tags and collections are optional; no mandatory filing ceremony.
7. Return to the book. Unreviewed text or missing metadata appears later in a review inbox.

Offer a second, faster path: Save photo now. This durably saves the image and chosen book as an incomplete capture, allowing selection, page confirmation, and notes later. Do not call this a verified quotation.

## 4 Use cases and expected behavior

| ID | Situation | Required behavior | Stage |
| --- | --- | --- | --- |
| UC01 | Begin a new book | Enter title and author manually, with optional edition details and cover | MVP |
| UC02 | Find a memorable line | Capture, extract text, select excerpt, save its source and location | MVP |
| UC03 | Want a digital underline | Apply a text annotation to selected words without altering source text or image | MVP |
| UC04 | Have an immediate reaction | Dictate or type a reflection attached to the passage | MVP |
| UC05 | Need silence in a library | Type a note or capture now and annotate later | MVP |
| UC06 | Want to keep reading quickly | Save an incomplete capture, then resume from the review inbox | MVP |
| UC07 | Read several books at once | Switch current book quickly and correct a capture assigned to the wrong book | MVP |
| UC08 | Passage crosses two pages | Attach ordered page captures to one passage with separate page labels | MVP |
| UC09 | Find two interesting passages on one page | Reuse the source image for separate passage records | MVP |
| UC10 | Have a thought about the whole book | Save a book-level reflection without requiring a quotation | MVP |
| UC11 | Cannot recall the exact wording | Search quotation and reflection text; filter by book, tag, page, or date | MVP |
| UC12 | Pull the physical book off the shelf | Open its notes sorted by printed page, and see the exact edition | MVP |
| UC13 | Revisit an idea months later | Append a dated reflection without overwriting the original reaction | MVP |
| UC14 | Prepare a blog post | Select passages from several books and export quotes, reflections, and source details | MVP basic; V1 workspace |
| UC15 | Notice recurring themes | Apply reusable tags across books; later get optional suggested connections | MVP manual; V2 AI |
| UC16 | Finish or reread a book | Keep historical notes; later group them into reading sessions | V1 |
| UC17 | Lose or replace a phone | Restore a complete archive; later also use iCloud sync | MVP archive; V1 sync |
| UC18 | Want a passage resurfaced | Optionally review favorites or receive gentle resurfacing reminders | V2 |
| UC19 | Add an older book without an ISBN | Manual creation remains fully functional | MVP |
| UC20 | Scan an ISBN | Suggest metadata and require confirmation of edition | V1 |
| UC21 | Remember a concept but none of its words | Semantic retrieval with links to the actual saved passages | V2 |
| UC22 | Annotate a diagram or illegible page | Save an image and reader note without inventing OCR text | MVP |

## 5 Feature priorities

### MVP A dependable personal reading tool

- Bookshelf with current books, manual creation, optional ISBN, publisher, publication year, edition, translator, and cover.
- Camera and image import; rotate, crop, retake, and retain source.
- On-device OCR and editable extracted text with original OCR retained separately.
- Passage selection, digital highlight or underline in the text view, page labels, and ordered multiple-page segments.
- Typed reflections with keyboard dictation available through the system; a dedicated recording and transcription button is a subsequent enhancement unless essential to the prototype.
- Optional lightweight tags, favorites, and a review inbox.
- Book and global keyword search, page ordering, and filtering.
- Autosaved drafts; visible saved or failed states; recovery after interruption.
- Share-sheet export of selected notes or a book to Markdown and plain text.
- Complete, versioned backup archive and restore, including media; deletion with undo or recoverable trash.

An initial engineering slice can be smaller than this MVP. Build one complete path through manual book creation, single-image OCR, a typed or keyboard-dictated reflection, persistence, search, and export first. Add the remaining MVP requirements before relying on the app as the only copy of reading notes.

### V1 Comfort and dependable use across devices

- Dedicated voice recording, editable transcript, optional retained audio, and explicit offline fallback.
- ISBN metadata lookup with provider choice, attribution requirements, and service terms verified during implementation.
- Optional iCloud sync, attachment transfer, status reporting where supported, and edit-conflict handling.
- iPad or Mac reading and writing interface if desktop composition proves important.
- Named collections and writing projects that reference existing passages rather than copying them.
- Related-passage links, bulk tagging, tag merging, reading sessions, and export layouts.
- A widget or shortcut to begin capture; an incoming share extension if user trials justify it.

### V2 Optional intelligence

- Suggest tags and connections between saved passages with a short explanation.
- Search by meaning and return the underlying notes as evidence.
- Generate a book-level summary of the reader's saved reflections, clearly labeled as incomplete coverage of the book.
- Create a draft blog outline from selected notes while preserving quotation attribution.
- Ask questions of the collection with clickable source passages and explicit insufficient-evidence responses.
- Resurface older notes and allow the reader to record how their thinking has changed.

Do not include social feeds, full-book scanning, automatic publishing, public quotation libraries, complex reading statistics, or a general-purpose writing editor in the first release.

## 6 Screens and navigation

Use three primary destinations: Books, Search, and Inbox, with an always-obvious Capture action. Settings can live behind a small toolbar control.

| Screen | Contents and primary actions |
| --- | --- |
| Books | Current books, all books, add book, resume capture |
| Book detail | Edition metadata, passages sorted by page or capture date, book-level reflections |
| Capture | Current book, camera or import, image preview, retake, quick save |
| Passage editor | Selected source text, page label, digital markup, add reflection, save |
| Passage detail | Quotation, source image toggle, location, dated reflections, tags, related items |
| Search | Keyword query, matching text snippets, filters, direct links to passage records |
| Inbox | Missing book/page, unreviewed OCR, incomplete captures, failed transcription |
| Settings | Privacy, media retention, export/restore, permissions, later sync and AI settings |
| Writing project in V1 | Ordered passage references, original reflections, outline notes, export |

Source images and exact quotation text must remain reachable from any writing export selection. Do not place AI suggestions inside the reader's reflection editor as though they had been dictated.

## 7 Information model

Use durable UUIDs, timestamps, schema versions, and explicit relationships. The logical model below is independent of any persistence framework's exact implementation.

| Entity | Important fields and relationships |
| --- | --- |
| BookEdition | ID, title, author names, optional translator, ISBN, publisher, year, edition label, cover reference, reading status |
| Capture | ID, source image asset, crop/rotation transform, raw OCR, detected text regions, OCR status, optional book assignment, timestamps |
| Passage | ID, book edition, selected quotation text, verification status, favorite flag, timestamps |
| PassageSegment | ID, passage, capture, ordered position, page label, optional sortable page number, chapter, source text/region anchors |
| TextAnnotation | ID, passage segment, underline/highlight style, text range, quoted anchor and surrounding context |
| Reflection | ID, passage or book owner, original transcript when available, current edited text, capture method, optional audio asset, timestamps |
| Tag | ID, display name, normalized matching key; many-to-many links to passages/reflections |
| MediaAsset | ID, relative local reference, media type, checksum, byte size, creation date; later remote sync reference |
| WritingProject in V1 | ID, title, outline notes, ordered references to passages and reflections |
| AISuggestion in V2 | ID, source IDs and versions, suggestion type, generated text, generation metadata, accepted/rejected status |

MVP can represent each physical edition directly as BookEdition. Add a shared literary Work entity only when grouping multiple editions becomes useful. Never automatically merge two editions because their titles match.

Page labels are strings: examples include 142, xiv, or unnumbered. Use an optional numeric sort field for ordinary pages and a separate sequence for front matter. Unknown locations remain unknown. Store passage segments separately so a two-page quotation retains accurate provenance.

Text offsets alone are fragile when OCR is corrected. Keep the selected anchor text, context, and optional image coordinates. After an edit, recompute anchors or mark them for review instead of silently moving an underline. Store a canonical quotation revision and invalidate affected annotations when needed.

## 8 Accuracy and preservation rules

1. Preserve the source image, raw OCR, and corrected quotation as distinct data.
2. The reader explicitly marks a quotation as checked. OCR confidence is a review signal, not proof.
3. Never let generative AI rewrite quotation text automatically. Suggested corrections require a diff and confirmation.
4. Preserve poetry line breaks and punctuation. Offer optional dehyphenation for prose; keep the original OCR for comparison.
5. Image highlighting is optional after MVP. If implemented, store normalized coordinates and crop transforms; never paint permanently onto the original image.
6. A quote, a reflection, and a generated suggestion must stay distinguishable in the app, exports, search results, and AI context.
7. Export book title, author, edition details when known, page label, and verification status. Missing information must not be fabricated.
8. Changing a book assignment or page location must not discard existing notes.
9. Re-OCR is an explicit action and must not overwrite approved quotation edits.

## 9 Failure cases and recovery

| Failure or edge case | Expected handling |
| --- | --- |
| Dim light, curved gutter, glare, tiny print | Offer retake/crop/manual correction; retain image even when OCR fails |
| Page number omitted by crop | Ask for optional manual page label; save as unknown if skipped |
| Headers, footnotes, columns, poetry | Allow selection and ordering corrections; preserve intentional line breaks |
| Camera denied | Offer image import or manual quote entry and a link to Settings |
| Microphone or speech denied | Keep typing usable; never block saving a passage |
| Offline transcription unavailable | Save typed text or, with consent, local audio for later transcription; show pending status |
| Incoming call, app backgrounding, crash | Save completed images and text promptly; recover the draft on next launch |
| Storage full or write failure | Never show Saved; keep the recoverable draft and explain retry/export options |
| Duplicate photograph | Suggest an existing capture; allow keeping both and do not silently merge |
| Same quote in different editions | Keep separate source records; optional user-created link |
| Very long passage or several pages | Ordered segments with per-page provenance and editable reading order |
| Attachment missing during sync/restore | Preserve text and display missing attachment state; allow retry |
| Simultaneous edits in V1 | Preserve conflicting versions for resolution; do not silently lose a reflection |
| Delete a book | Explain affected records, move to trash, provide recovery before permanent deletion |
| AI unavailable or wrong in V2 | Core app continues; suggestions are disposable and separately stored |

## 10 Technical direction and feasibility

Recommended starting stack: Swift, SwiftUI, a local persistence layer using SwiftData, and Apple Vision for still-image OCR. Treat this as an architecture proposal, not a commitment to a deployment target. Select the minimum iOS version after checking the actual test phone, Xcode version, and required APIs.

Apple documents that Vision can recognize text in images on device and return text observations with confidence values and bounding boxes [1]. That makes local OCR a practical first implementation. Prefer still-image capture and review before building a live scanner.

For the first slice, use a standard text editor that supports the system keyboard's dictation. A dedicated voice workflow requires additional audio capture, interruption handling, permission handling, and transcription state management. Apple exposes an on-device speech-recognition capability check; its documented API requires a network if that capability is false [2]. Do not promise universal offline dictation. Evaluate the current Speech APIs and supported languages when implementing the dedicated recorder.

SwiftData offers iCloud synchronization with a compatible CloudKit schema [3]. Design for compatibility early but enable sync in a separate milestone. Apple's documented constraints include optional relationships and lack of CloudKit-enforced unique constraints. Use application-level identity and validation. Do not promise immediate sync, and do not confuse sync with a recoverable backup.

Media stored merely as local file URLs will not automatically appear on another device. Before enabling sync, choose and validate an attachment strategy, such as framework-supported binary storage or explicit CloudKit assets, with file size, retry, deletion, and restore behavior tested.

Separate components behind narrow interfaces: OCRService, CaptureService, BookRepository, PassageRepository, SearchService, ExportService, and later SpeechService and SuggestionService. Do not add a server to the MVP unless a concrete requirement demands one.

Start with local keyword search across quotations, reflections, titles, authors, and tags. Benchmark at 10,000 passages before adding a separate full-text index; add one if measured performance requires it. Semantic search belongs in a later milestone.

A native build and real-device validation require an appropriate Mac/Xcode setup and Apple signing configuration. CloudKit capability and distribution setup are separate implementation tasks. Confirm these prerequisites before asking an AI assistant to promise an installable build.

## 11 Privacy and durable ownership

- Store content locally by default. Do not send images, audio, quotations, or personal notes to external AI without a clear opt-in identifying the service and selected data.
- Ask for camera and audio permissions when the feature is used. Use a system photo picker for import where appropriate.
- Keep text and audio out of analytics, crash logs, and debug logs. Use platform file protection for local assets.
- Do not save captures into the public photo library unless the user chooses that behavior.
- For dedicated recording, default to deleting raw audio after the reader accepts the transcript; offer deliberate retention or immediate deletion. Explain that deletion may propagate through sync.
- Add optional app locking later if needed. Do not describe the app as end-to-end encrypted without verifying the full storage and service design.
- Export selected material for writing. Keep source images out of the ordinary blog export by default; full backup archives include retained media.
- Keep publishing a deliberate action outside the MVP. Attribution and editorial review stay visible in the workflow.

The full archive should contain a versioned JSON manifest, stable record IDs, relationship data, quotation and reflection text, annotations, tags, and retained media with checksums. Markdown is useful for writing but is not a full-fidelity backup. Restore should validate the archive first, preview its contents, and explain merge versus replacement. Test restore into a clean app installation.

## 12 Writing workflow

1. Search a subject such as memory, identity, or belonging.
2. Select passages and reflections across books.
3. Review quotation accuracy and missing page or edition information.
4. Export in chosen order. Each entry includes quotation, attribution/location, and a separately labeled My reflection section.
5. In V1, collect these references in a writing project and add an outline.
6. In V2, optionally ask AI for themes or an outline using only selected records, with source links.

Suggested Markdown layout:

```markdown
## A topic I want to explore

### Book title — Author, edition details, p. 142

> Exact quotation, checked against the source photograph.

My reflection — October 17, 2026

My own observations and questions go here.

Tags: memory, identity
Source record: stable passage ID
Verification: checked by reader
```

Use placeholder or public-domain text for fixtures and demonstrations. Before sharing, the reader chooses which excerpts and personal reflections to include. The app must never publish on its own.

## 13 Build milestones and completion gates

| Milestone | Deliverable | Gate before proceeding |
| --- | --- | --- |
| 0 Prototype | Capture-to-save interface with sample content | Reader can use it one-handed without excessive setup |
| 1 Vertical slice | One book, one page image, OCR, selection, reflection, local save, search, Markdown export | Complete path works on a real iPhone and persists after relaunch |
| 2 MVP completion | Multipage passages, text markup, inbox, tagging, robust errors, backup/restore, accessibility | Recovery and archive round-trip pass; no quotation/reflection mixing |
| 3 Personal trial | Use with several books for one or two weeks | Observe friction, retrieval success, OCR corrections, and media growth |
| 4 V1 | Dedicated speech, metadata lookup, sync, writing collections as justified | Offline and two-device conflict tests pass; no missing media |
| 5 Optional AI | Suggestions, semantic search, grounded writing assistance | No silent source edits; source links and no-evidence behavior verified |

The personal trial should determine priorities. Measure capture time from opening Capture to durable save, excluding the time spent speaking. A proposed target is a median below 30 seconds for a short passage in normal lighting; this is a design target, not a current performance claim.

Other proposed targets: immediate draft recovery after relaunch; keyword results within roughly one second on the chosen reference device at 10,000 passages; exact restoration of text, relationships, and media from a backup. Record device, dataset, and conditions when evaluating performance.

## 14 Acceptance scenarios for coding and review

```gherkin
Feature: Preserve reading notes without marking a book

Scenario: Save a passage and reflection
  Given I have selected a book edition
  When I photograph a page, select recognized text, enter page 142, and add a reflection
  Then the app saves the source image, quotation, location, and reflection separately
  And the same passage and reflection are present after I relaunch the app

Scenario: Work without a page number
  Given the page number is not visible
  When I save without entering a page label
  Then the location is unknown and the capture is available for later review
  And no page number is invented

Scenario: Correct OCR without losing the source
  Given a saved quotation contains a recognition error
  When I correct the quotation
  Then the original image and raw OCR remain unchanged
  And affected text annotations are reanchored or flagged for review

Scenario: Preserve a passage across pages
  Given a passage begins on page 142 and ends on page 143
  When I attach both captures in order
  Then the saved passage retains both page labels and source images

Scenario: Capture offline
  Given the phone has no network connection
  When I capture a page and type a reflection
  Then OCR, local saving, and keyword retrieval still work
  And unavailable voice transcription does not block saving

Scenario: Recover an interrupted capture
  Given the source image and a draft reflection have been durably saved
  When the app terminates before I finish reviewing the quotation
  Then relaunching offers the unfinished draft with those saved contents intact

Scenario: Restore a complete backup
  Given an archive containing books, passages, annotations, reflections, tags, and media
  When I restore it into a clean installation
  Then record identities, relationships, text, and media checksums match the archive

Scenario: Export material for a blog
  Given I select passages from two books
  When I export them as Markdown
  Then each quotation includes its available source information and verification status
  And my reflections are labeled separately from the quotations

Scenario: Decline AI processing
  Given external AI features are disabled
  When I capture, annotate, search, and export
  Then the core workflow works without sending content to an AI provider
```

Also exercise denied permissions, Unicode/poetry, full storage, wrong-book reassignment, duplicate captures, image rotation, large Dynamic Type, VoiceOver, deletion recovery, and export filenames. Test concurrency and sync only when those features are introduced. Use meaningful behavior tests and real-device capture checks rather than tests that merely repeat implementation details.

## 15 Copyable master prompt for an AI coding assistant

```text
Act as my senior iOS engineer and product collaborator. Build a private native
iPhone app called Book Companion using the attached blueprint as the product
specification. The user photographs passages in physical books, selects exact
quotations, adds typed or dictated reflections, and retrieves them later by
book, edition, page, keyword, or tag for personal reading and blog preparation.

Start by inspecting the repository and any AGENTS.md instructions. If there is
no project, propose the smallest appropriate SwiftUI project structure. Check
the available Xcode/SDK, signing setup, and test device assumptions before
choosing a minimum iOS deployment target. Verify current Apple APIs in official
documentation. Do not claim a simulator or device run unless it occurred.

Implement Milestone 1 only first: manual book creation, one-page image capture
or import, on-device Vision OCR, editable excerpt selection, an optional page
label, a reflection editor supporting normal system keyboard dictation, durable
local persistence, keyword retrieval, and Markdown export through the share sheet.

Preserve source images, original OCR, and edited quotation text separately.
Keep reader reflections separate from quotations. Unknown pages remain unknown.
Save drafts early and expose failed saves honestly. Do not fabricate OCR text,
book metadata, page numbers, or unavailable service behavior. Use dependency
interfaces for OCR and storage so meaningful failure paths can be tested.

Use SwiftUI and a suitable local persistence layer, with SwiftData as the
preferred starting option. Design stable IDs, schema migration, and media
references with future CloudKit compatibility in mind. Do not enable cloud sync,
external AI, paid services, ISBN lookup, or automatic publication in this milestone.

Implement incrementally in working slices. Include relevant acceptance tests,
instructions for opening/building the project, permissions and signing setup,
and a concise manual iPhone test checklist. After each slice, report what works,
what was actually tested, and remaining limitations. Keep the interface readable
with Dynamic Type and accessibility labels. Use synthetic or public-domain fixtures.

Proceed with reasonable reversible choices. Ask only when a missing answer
materially changes architecture or requires credentials, purchases, or access.
Complete the first usable end-to-end path before expanding scope.
```

Subsequent prompt: “Implement Milestone 2 from the blueprint. First assess the existing implementation, preserve working behavior, and prioritize data preservation, text annotations, multiple-page provenance, the review inbox, and full backup/restore. Demonstrate the relevant acceptance scenarios before proposing sync.”

## 16 Decisions to revisit after the first prototype

| Decision | Proposed default | When it matters |
| --- | --- | --- |
| Personal app or product for others | Personal app first | Before onboarding, billing, support, or distribution design |
| Phone-only or desktop writing | Capture on iPhone; Markdown export for writing elsewhere | Before building sync or a web interface |
| Voice interaction | Keyboard dictation first; dedicated recorder next | After observing actual capture friction |
| Retain source photos | Yes, with user-controlled deletion | Before optimizing storage |
| Raw recorded audio | Delete after accepted transcription unless retained deliberately | When adding dedicated recording |
| AI use | Off by default, selected content only | Before integrating a provider |
| Capture layout | Readable text annotations first; image overlays later | After testing selection accuracy |
| Organizing method | Books plus a small reusable tag vocabulary | After the collection grows |

## 17 Technical references

Official Apple documentation checked October 17, 2026. API availability and implementation details must be rechecked against the build SDK.

1. [Recognizing Text in Images](https://developer.apple.com/documentation/vision/recognizing-text-in-images) — on-device OCR, recognition observations, confidence, and image text coordinates.
2. [supportsOnDeviceRecognition](https://developer.apple.com/documentation/speech/sfspeechrecognizer/supportsondevicerecognition) — capability-dependent offline speech recognition.
3. [Syncing model data across a person's devices](https://developer.apple.com/documentation/swiftdata/syncing-model-data-across-a-persons-devices) — iCloud configuration and SwiftData/CloudKit schema constraints.
