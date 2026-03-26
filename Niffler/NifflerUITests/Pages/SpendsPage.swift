import XCTest

class SpendsPage: BasePage {

    // MARK: - UI Elements

    private var addSpendButton: XCUIElement {
        app.buttons["addSpendButton"]
    }

    private var menuButton: XCUIElement {
        app.buttons["menuButton"]
    }

    private var spendsScrollView: XCUIElement {
        app.firstMatch.scrollViews.firstMatch
    }

    private var firstSwitch: XCUIElement {
        spendsScrollView.switches.firstMatch
    }

    private var emptyStateElement: XCUIElement {
        app.staticTexts.matching(identifier: "emptySpendsList").firstMatch
    }

    // MARK: - Navigation

    @discardableResult
    func openAddSpendForm() -> Self {
        XCTContext.runActivity(named: "Шаг: Открытие формы добавления траты") { _ in
            addSpendButton.tap()
        }
        return self
    }

    @discardableResult
    func openMenu() -> Self {
        XCTContext.runActivity(named: "Шаг: Открытие меню") { _ in
            menuButton.tap()
        }
        return self
    }

    // MARK: - Waits

    @discardableResult
    func waitForSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидание: Экран трат") { _ in
            let isFound = firstSwitch.waitForExistence(timeout: 10)

            XCTAssertTrue(isFound,
                          "Не дождались экрана со списком трат",
                          file: file, line: line)
        }
        return self
    }

    // MARK: - Assertions

    @discardableResult
    func assertSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Экран трат отображается") { _ in
            waitForSpendsScreen(file: file, line: line)
            XCTAssertGreaterThanOrEqual(spendsScrollView.switches.count, 1,
                                        "Не найдено трат в списке",
                                        file: file, line: line)
        }
        return self
    }

    @discardableResult
    func assertEmptySpendsList(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Список трат пустой") { _ in
            let isFound = emptyStateElement.waitForExistence(timeout: 5)

            XCTAssertTrue(isFound,
                          "Пустой экран трат не найден",
                          file: file, line: line)
        }
        return self
    }

    @discardableResult
    func assertSpendIsShown(_ title: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Трата '\(title)' отображается") { _ in
            let isFound = spendsScrollView
                .staticTexts[title].firstMatch
                .waitForExistence(timeout: 5)

            XCTAssertTrue(isFound,
                          "Трата '\(title)' не найдена",
                          file: file, line: line)
        }
        return self
    }
}
