import InlineSnapshotTesting
import TestCases
import XCTest

@MainActor
final class iOS16_17_OldPresentsNewTests: BaseIntegrationTests {
  override func setUp() {
    super.setUp()
    self.app.buttons["iOS 16 + 17"].tap()
    self.app.buttons["Old presents new"].tap()
    self.clearLogs()
    // SnapshotTesting.isRecording = true
  }

  func testBasics() {
    self.app.buttons["Increment"].tap()
    XCTAssertEqual(self.app.staticTexts["1"].exists, true)
    self.assertLogs {
      """
      OldPresentsNewTestCase.body
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  // TODO: Flakey test
  func testPresentChild_NotObservingChildCount() {
    self.app.buttons["Present child"].tap()
    self.assertLogs {
      """
      ObservableBasicsView.body
      OldPresentsNewTestCase.body
      OldPresentsNewTestCase.body
      PresentationStoreOf<ObservableBasicsView.Feature>.deinit
      PresentationStoreOf<ObservableBasicsView.Feature>.init
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.deinit
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.init
      StoreOf<ObservableBasicsView.Feature>.init
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  // TODO: Flakey test
  func testDismissChild_NotObservingChildCount() {
    self.app.buttons["Present child"].tap()
    self.clearLogs()
    self.app.buttons["Dismiss"].tap()
    self.assertLogs {
      """
      OldPresentsNewTestCase.body
      PresentationStoreOf<ObservableBasicsView.Feature>.init
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.init
      StoreOf<ObservableBasicsView.Feature>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  func testObserveChildCount() {
    self.app.buttons["Toggle observe child count"].tap()
    XCTAssertEqual(self.app.staticTexts["Child count: N/A"].exists, true)
    self.assertLogs {
      """
      OldPresentsNewTestCase.body
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  // TODO: Flakey test
  func testPresentChild_ObservingChildCount() {
    self.app.buttons["Toggle observe child count"].tap()
    self.clearLogs()
    self.app.buttons["Present child"].tap()
    self.assertLogs {
      """
      ObservableBasicsView.body
      OldPresentsNewTestCase.body
      OldPresentsNewTestCase.body
      PresentationStoreOf<ObservableBasicsView.Feature>.deinit
      PresentationStoreOf<ObservableBasicsView.Feature>.init
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.deinit
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.init
      StoreOf<ObservableBasicsView.Feature>.init
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  func testIncrementChild_ObservingChildCount() {
    self.app.buttons["Toggle observe child count"].tap()
    self.app.buttons["Present child"].tap()
    self.clearLogs()
    self.app.buttons.matching(identifier: "Increment").element(boundBy: 0).tap()
    XCTAssertEqual(self.app.staticTexts["1"].exists, true)
    XCTAssertEqual(self.app.staticTexts["Child count: 1"].exists, true)
    self.assertLogs {
      """
      ObservableBasicsView.body
      ObservableBasicsView.body
      OldPresentsNewTestCase.body
      OldPresentsNewTestCase.body
      PresentationStoreOf<ObservableBasicsView.Feature>.init
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.init
      StoreOf<ObservableBasicsView.Feature>.init
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  // TODO: Flakey test
  func testDismissChild_ObservingChildCount() {
    self.app.buttons["Toggle observe child count"].tap()
    self.app.buttons["Present child"].tap()
    self.clearLogs()
    self.app.buttons["Dismiss"].tap()
    self.assertLogs {
      """
      OldPresentsNewTestCase.body
      OldPresentsNewTestCase.body
      PresentationStoreOf<ObservableBasicsView.Feature>.init
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      PresentationStoreOf<ObservableBasicsView.Feature>.scope
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.init
      StoreOf<ObservableBasicsView.Feature>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.init
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<ObservableBasicsView.Feature?>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      StoreOf<OldPresentsNewTestCase.Feature>.scope
      """
    }
  }

  func testDeinit() {
    self.app.buttons["Toggle observe child count"].tap()
    self.app.buttons["Present child"].tap()
    self.app.buttons.matching(identifier: "Increment").element(boundBy: 0).tap()
    self.app.buttons["Dismiss"].tap()
    self.clearLogs()
    self.app.buttons["iOS 16 + 17"].tap()
    self.assertLogs {
      """
      PresentationStoreOf<ObservableBasicsView.Feature>.deinit
      Store<OldPresentsNewTestCase.ViewState, OldPresentsNewTestCase.Feature.Action>.deinit
      StoreOf<ObservableBasicsView.Feature?>.deinit
      """
    }
  }
}
