import XCTest

/// Walks the capture-to-save path the way a reader would, at the default text
/// size and at the largest accessibility size. Screenshots are kept in the test
/// results for review.
final class CaptureFlowUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCaptureAndSaveWithUnknownPage() throws {
        let app = XCUIApplication()
        app.launch()
        try runCaptureFlow(in: app, screenshotPrefix: "default")
    }

    @MainActor
    func testCaptureAndSaveAtLargestTextSize() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        try runCaptureFlow(in: app, screenshotPrefix: "accessibility-xxxl")
    }

    @MainActor
    func testCancelAsksBeforeDiscardingTypedText() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["captureButton"].tap()

        let reflection = app.textFields["reflectionField"]
        XCTAssertTrue(reflection.waitForExistence(timeout: 5))
        reflection.tap()
        reflection.typeText("A thought")
        app.buttons["cancelPassage"].tap()

        let keepEditing = app.buttons["Keep editing"]
        XCTAssertTrue(keepEditing.waitForExistence(timeout: 5))
        keepScreenshot(of: app, named: "default-5-discard")
        keepEditing.tap()
        XCTAssertEqual(reflection.value as? String, "A thought")

        app.buttons["cancelPassage"].tap()
        app.buttons["Discard"].tap()
        XCTAssertTrue(app.buttons["captureButton"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func runCaptureFlow(in app: XCUIApplication, screenshotPrefix: String) throws {
        let capture = app.buttons["captureButton"]
        XCTAssertTrue(capture.waitForExistence(timeout: 10))
        XCTAssertEqual(capture.label, "Capture a passage from Walden")
        keepScreenshot(of: app, named: "\(screenshotPrefix)-1-books")

        capture.tap()
        let save = app.buttons["savePassage"]
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["cancelPassage"].exists)
        keepScreenshot(of: app, named: "\(screenshotPrefix)-2-new-passage")

        // At the largest text sizes the page field and Finish later start below
        // the fold, and may not fit on screen together.
        let pageField = app.textFields["pageLabelField"]
        for _ in 0..<6 where !pageField.exists {
            app.swipeUp()
        }
        XCTAssertTrue(pageField.exists)
        let finishLater = app.buttons["finishLater"]
        for _ in 0..<6 where !finishLater.exists {
            app.swipeUp()
        }
        XCTAssertTrue(finishLater.exists)
        keepScreenshot(of: app, named: "\(screenshotPrefix)-3-new-passage-scrolled")

        save.tap()
        XCTAssertTrue(capture.waitForExistence(timeout: 5))

        app.tabBars.buttons["Inbox"].tap()
        XCTAssertTrue(app.staticTexts["Page unknown"].firstMatch.waitForExistence(timeout: 5))
        keepScreenshot(of: app, named: "\(screenshotPrefix)-4-inbox")
    }

    @MainActor
    private func keepScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
