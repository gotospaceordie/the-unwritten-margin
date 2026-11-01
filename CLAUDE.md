# CLAUDE.md — The Unwritten Margin

Read this whole file before doing anything in this repository. When this file and Paul disagree, Paul wins; propose an edit to this file so the next session inherits the rule.

## What this is

**The Unwritten Margin** is a private iPhone app for readers who won't write in their books. It saves exact quotations from physical books, with edition and page, alongside the reader's own reflections.

It is **not** an e-reader, a social network, a full-book scanner, a publishing tool, or a general writing editor.

The product specification is `docs/Book-Companion-App-Blueprint.md`. Treat it as the source of truth for behaviour; where it says "proposed", it is a default that can change on Paul's word.

## Priorities, in order

1. **Data preservation.** Never lose or silently alter a quotation, reflection, image, or page label.
2. **Privacy.** Local-first. Nothing leaves the device without an explicit opt-in.
3. **Capture speed.** Capturing a thought should interrupt reading as little as possible.
4. **Polish.**

When two of these conflict, the higher one wins.

## Stack

- Swift, SwiftUI, SwiftData, Apple Vision (on-device OCR). Native iOS only.
- Built and tested on Paul's Mac (MacBook Air M4, macOS Tahoe) with Xcode.
- Keep components behind narrow protocols (`OCRService`, `CaptureService`, `BookRepository`, `PassageRepository`, `SearchService`, `ExportService`) so failure paths can be tested with fakes.
- No server, no third-party SDKs, no analytics, no paid services unless an issue says so and Paul agreed.
- Check current Apple documentation for APIs; do not rely on memory for availability or deployment targets.

Build and test commands: _to be filled in once the Xcode project exists._

## About Paul

Paul is an experienced C#/.NET developer and new to Swift and iOS. He likes detailed, verbose explanations. When you introduce a Swift or iOS concept, give the nearest C#/.NET equivalent in a sentence (for example: a Swift `protocol` is close to a C# `interface`; `async let` is close to starting several `Task`s and awaiting them).

Quiet hours: midnight to 8am US Central. Hold anything non-urgent.

## Never do

1. **Never push secrets. Always check before pushing.** This repository is public. Before every `git push`, review the full diff (`git diff origin/main...HEAD`) for: API keys, tokens, passwords, `.p12`/`.mobileprovision`/`.cer` files, `.env` files, signing team IDs in plain config, email addresses, and personal data. If anything looks sensitive, stop and ask Paul. GitHub push protection is a backstop, not a substitute.
2. **Never commit real reading data.** No real photographs of pages, no copyrighted book text, no personal reflections. Fixtures and screenshots use synthetic or public-domain text only.
3. **Never fabricate.** No invented OCR text, book metadata, page numbers, or test results. Unknown stays unknown.
4. **Never claim what you didn't run.** Say "built on simulator X", "tested on device", or "not run" exactly as it happened.
5. **Never let AI or code rewrite quotation text automatically.** Corrections need a visible diff and the reader's confirmation.

## How work flows

GitHub issues are the shared record. Every decision that matters is written on an issue.

1. **One issue, one branch.** Name it `issue-<number>-<short-slug>`. Never commit directly to `main`.
2. **Step 0 before code.** Read the issue and the relevant code. Post one comment with:
   - what you found, with file and line;
   - any premise in the issue that is wrong;
   - your plan, in a few steps;
   - **ASK:** numbered questions, each with your recommendation and the alternatives.
   Then wait for an answer if there are questions that change the design. If there are none, say so and proceed.
3. **Build in small, working commits.** Keep the app building at every commit.
4. **Open a pull request** that closes the issue (`Closes #N`). CI must be green.
5. **Paul merges.** Do not merge your own PR unless Paul says so on that PR or issue.
6. **Ship report** as the last PR comment: what changed, what was tested and how, what Paul should check on his iPhone, and any follow-up issues you propose (proposed, not filed).

## Tests

- Write behavioural tests that pin what the app must do (see blueprint §14 acceptance scenarios), not tests that repeat the implementation.
- Every rule in "Accuracy and preservation" (blueprint §8) that you touch needs a test that would fail if the rule were broken.
- Screenshot golden tests and mutation testing come later; do not add them until an issue asks.

## Accuracy and preservation (summary of blueprint §8)

- Source image, raw OCR, and corrected quotation are separate, stored data.
- Quotations, reflections, and any generated text are distinct fields and visibly distinct in the UI and exports.
- Page labels are strings (`142`, `xiv`, `unnumbered`); unknown pages are stored as unknown.
- Re-OCR never overwrites approved quotation edits.
- Changing a book or page assignment never discards notes.
- A save that failed never shows "Saved".
