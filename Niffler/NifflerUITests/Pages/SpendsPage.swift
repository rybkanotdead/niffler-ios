import XCTest

class SpendsPage: BasePage {

    // MARK: - Navigation

    @discardableResult
    func openAddSpendForm() -> Self {
        XCTContext.runActivity(named: "Шаг: Открытие формы добавления траты") { _ in
            app.buttons["addSpendButton"].tap()
        }
        return self
    }

    @discardableResult
    func openMenu() -> Self {
        XCTContext.runActivity(named: "Шаг: Открытие меню") { _ in
            // Предполагаем, что есть кнопка меню
            app.buttons["menuButton"].tap()
        }
        return self
    }

    // MARK: - Waits

    @discardableResult
    func waitForSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидание: Экран трат") { _ in
            let isFound = app.firstMatch
                .scrollViews.firstMatch
                .switches.firstMatch
                .waitForExistence(timeout: 10)

            XCTAssertTrue(isFound,
                          "❌ Не дождались экрана со списком трат",
                          file: file, line: line)
        }
        return self
    }

    // MARK: - Assertions

    @discardableResult
    func assertSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Экран трат отображается") { _ in
            waitForSpendsScreen(file: file, line: line)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1,
                                        "❌ Не нашел трат в списке",
                                        file: file, line: line)
        }
        return self
    }

    @discardableResult
    func assertEmptySpendsList(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Список трат пустой") { _ in
            let emptyState = app.staticTexts.matching(identifier: "emptySpendsList").firstMatch
            let isFound = emptyState.waitForExistence(timeout: 5)

            XCTAssertTrue(isFound,
                          "❌ Пустой экран трат не найден",
                          file: file, line: line)
        }
        return self
    }

    @discardableResult
    func assertSpendIsShown(_ title: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Трата '\(title)' отображается") { _ in
            let isFound = app.firstMatch
                .scrollViews.firstMatch
                .staticTexts[title].firstMatch
                .waitForExistence(timeout: 5)

            XCTAssertTrue(isFound,
                          "❌ Трата '\(title)' не найдена",
                          file: file, line: line)
        }
        return self
    }

    // MARK: - Legacy compatibility methods (deprecated)

    @available(*, deprecated, renamed: "waitForSpendsScreen")
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        return waitForSpendsScreen(file: file, line: line)
    }

    @available(*, deprecated, renamed: "openAddSpendForm")
    func addSpent() {
        openAddSpendForm()
    }

    @available(*, deprecated, renamed: "assertSpendIsShown")
    func assertNewSpendIsShown(title: String, file: StaticString = #filePath, line: UInt = #line) {
        assertSpendIsShown(title, file: file, line: line)
    }

    @available(*, deprecated, renamed: "assertSpendsViewAppeared")
    func assertIsSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) {
        assertSpendsViewAppeared(file: file, line: line)
    }
}
