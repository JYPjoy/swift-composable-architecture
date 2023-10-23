import InlineSnapshotTesting
import TestCases
import XCTest

@MainActor
final class iOS16_OptionalTests: BaseIntegrationTests {
  override func setUp() {
    super.setUp()
    self.app.buttons["iOS 16"].tap()
    self.app.buttons["Optional"].tap()
    self.clearLogs()
    // SnapshotTesting.isRecording = true
  }

  func testBasics() {
    self.app.buttons["Toggle"].tap()
    self.assertLogs {
      """
      BasicsView.body
      OptionalView.body
      PresentationStoreOf<BasicsView.Feature>.deinit
      PresentationStoreOf<BasicsView.Feature>.init
      PresentationStoreOf<BasicsView.Feature>.scope
      Store<OptionalView.ViewState, OptionalView.Feature.Action>.deinit
      Store<OptionalView.ViewState, OptionalView.Feature.Action>.init
      StoreOf<BasicsView.Feature>.deinit
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<OptionalView.Feature>.scope
      """
    }
    self.app.buttons["Increment"].tap()
    self.assertLogs {
      """
      BasicsView.body
      OptionalView.body
      OptionalView.body
      PresentationStoreOf<BasicsView.Feature>.init
      PresentationStoreOf<BasicsView.Feature>.scope
      Store<OptionalView.ViewState, OptionalView.Feature.Action>.deinit
      Store<OptionalView.ViewState, OptionalView.Feature.Action>.init
      StoreOf<BasicsView.Feature>.deinit
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.scope
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<OptionalView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      """
    }
  }

  func testParentObserveChild() {
    self.app.buttons["Toggle"].tap()
    self.app.buttons["Increment"].tap()
    self.clearLogs()
    self.app.buttons["Observe count"].tap()
    XCTAssertEqual(self.app.staticTexts["Count: 1"].exists, true)
    self.assertLogs {
      """
      OptionalView.body
      StoreOf<OptionalView.Feature>.scope
      """
    }
    self.app.buttons["Increment"].tap()
    self.assertLogs {
      """
      BasicsView.body
      OptionalView.body
      OptionalView.body
      PresentationStoreOf<BasicsView.Feature>.deinit
      PresentationStoreOf<BasicsView.Feature>.init
      PresentationStoreOf<BasicsView.Feature>.scope
      PresentationStoreOf<BasicsView.Feature>.scope
      Store<OptionalView.ViewState, OptionalView.Feature.Action>.deinit
      Store<OptionalView.ViewState, OptionalView.Feature.Action>.init
      StoreOf<BasicsView.Feature>.deinit
      StoreOf<BasicsView.Feature>.deinit
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.scope
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.deinit
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.init
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<BasicsView.Feature?>.scope
      StoreOf<OptionalView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      """
    }
  }
}