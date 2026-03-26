import XCTest

class ProfilePage: BasePage {

    // MARK: - Navigation

    @discardableResult
    func openProfile() -> Self {
        XCTContext.runActivity(named: "Шаг: Открытие профиля") { _ in
            app.buttons["profileButton"].tap()
        }
        return self
    }

    @discardableResult
    func closeProfile() -> Self {
        XCTContext.runActivity(named: "Шаг: Закрытие профиля") { _ in
            app.buttons["closeProfileButton"].tap()
        }
        return self
    }

    // MARK: - Category Actions

    func getCategoriesList() -> [String] {
        XCTContext.runActivity(named: "Получение списка категорий") { _ in
            var categories: [String] = []
            let categoryTexts = app.staticTexts.allElementsBoundByIndex

            for element in categoryTexts {
                let identifier = element.identifier
                if identifier.starts(with: "category_") {
                    let categoryName = identifier.replacingOccurrences(of: "category_", with: "")
                    categories.append(categoryName)
                }
            }

            return categories
        }
    }

    func deleteCategory(_ categoryName: String) {
        XCTContext.runActivity(named: "Шаг: Удаление категории '\(categoryName)'") { _ in
            let categoryElement = app.staticTexts["category_\(categoryName)"]

            if categoryElement.exists {
                // Свайп влево для удаления
                categoryElement.swipeLeft()

                // Нажимаем кнопку Delete
                app.buttons["Delete"].tap()
            }
        }
    }

    // MARK: - Assertions

    func assertCategoryExists(_ categoryName: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка: Категория '\(categoryName)' существует") { _ in
            let category = app.staticTexts["category_\(categoryName)"]
            let exists = category.waitForExistence(timeout: 3)

            XCTAssertTrue(exists,
                          "Категория '\(categoryName)' не найдена в профиле",
                          file: file, line: line)
        }
    }

    func assertCategoryDoesNotExist(_ categoryName: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка: Категория '\(categoryName)' не существует") { _ in
            let category = app.staticTexts["category_\(categoryName)"]

            // Даем немного времени на обновление UI
            sleep(1)

            XCTAssertFalse(category.exists,
                          "Категория '\(categoryName)' все еще присутствует в профиле",
                          file: file, line: line)
        }
    }

    func assertCategoriesCount(_ expectedCount: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка: Количество категорий = \(expectedCount)") { _ in
            let categories = getCategoriesList()

            XCTAssertEqual(categories.count, expectedCount,
                          "Ожидалось \(expectedCount) категорий, найдено \(categories.count)",
                          file: file, line: line)
        }
    }
}
