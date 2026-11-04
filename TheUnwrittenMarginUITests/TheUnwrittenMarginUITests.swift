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
    private func runCaptureFlow(in app: XCUIApplication, screenshotPrefix: String) throws {
        let capture = app.buttons["captureButton"]
        XCTAssertTrue(capture.waitForExistence(timeout: 10))
        XCTAssertEqual(capture.label, "Capture a passage from Walden")
        keepScreenshot(of: app, named: "\(screenshotPrefix)-1-books")

        capture.tap()
        let useThisPage = app.buttons["useThisPage"]
        XCTAssertTrue(useThisPage.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["savePhotoNow"].exists)
        keepScreenshot(of: app, named: "\(screenshotPrefix)-2-capture")

        useThisPage.tap()
        let save = app.buttons["savePassage"]
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        // At the largest text sizes the page field starts below the fold.
        let pageField = app.textFields["pageLabelField"]
        for _ in 0..<5 where !pageField.exists {
            app.swipeUp()
        }
        XCTAssertTrue(pageField.exists)
        keepScreenshot(of: app, named: "\(screenshotPrefix)-3-editor")

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
