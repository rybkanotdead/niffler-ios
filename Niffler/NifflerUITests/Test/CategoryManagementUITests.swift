import XCTest

final class CategoryManagementUITests: TestCase {

    // MARK: - Test: Проверка добавления категории при создании траты

    func test_categoryAppearsInProfileAfterAddingSpend() throws {
        XCTContext.runActivity(named: "Тест: Категория появляется в профиле после добавления траты") { _ in
            // Arrange
            prepareTestEnvironment()
            let newCategoryName = "ТестоваяКатегория_\(UUID().uuidString.prefix(6))"

            // Act - Получаем начальное количество категорий
            let initialCategoriesCount = getInitialCategoriesCount()

            // Act - Добавляем трату с новой категорией
            addSpendWithNewCategory(categoryName: newCategoryName)

            // Assert - Проверяем, что категория появилась в профиле
            verifyNewCategoryAddedToProfile(
                categoryName: newCategoryName,
                expectedCount: initialCategoriesCount + 1
            )
        }
    }

    // MARK: - Test: Проверка удаления категории из профиля

    func test_deletedCategoryDoesNotAppearInNewSpend() throws {
        XCTContext.runActivity(named: "Тест: Удаленная категория не появляется при создании траты") { _ in
            // Arrange
            prepareTestEnvironment()
            let categoryToDelete = "Рыбалка" // Существующая категория

            // Act - Удаляем категорию из профиля
            deleteCategoryFromProfile(categoryName: categoryToDelete)

            // Assert - Проверяем, что категория не появляется при создании новой траты
            verifyDeletedCategoryNotAvailableInNewSpend(categoryName: categoryToDelete)
        }
    }

    // MARK: - Helper Methods

    private func prepareTestEnvironment() {
        XCTContext.runActivity(named: "Подготовка: Запуск и авторизация") { _ in
            launchAppWithoutLogin()
            loginPage.input(login: "stage", password: "12345")
            spendsPage.waitSpendsScreen()
        }
    }

    private func getInitialCategoriesCount() -> Int {
        XCTContext.runActivity(named: "Шаг: Получение начального количества категорий") { _ in
            profilePage.openProfile()
            let count = profilePage.getCategoriesList().count
            profilePage.closeProfile()
            return count
        }
    }

    private func addSpendWithNewCategory(categoryName: String) {
        XCTContext.runActivity(named: "Действие: Добавление траты с категорией '\(categoryName)'") { _ in
            spendsPage.addSpent()
            newSpendPage.inputSpentWithNewCategory(title: "Тестовая трата", categoryName: categoryName)

            // Ждем завершения добавления траты
            sleep(2)
        }
    }

    private func verifyNewCategoryAddedToProfile(categoryName: String, expectedCount: Int) {
        XCTContext.runActivity(named: "Проверка: Новая категория добавлена в профиль") { _ in
            profilePage.openProfile()
            profilePage.assertCategoryExists(categoryName)
            profilePage.assertCategoriesCount(expectedCount)
            profilePage.closeProfile()
        }
    }

    private func deleteCategoryFromProfile(categoryName: String) {
        XCTContext.runActivity(named: "Действие: Удаление категории '\(categoryName)' из профиля") { _ in
            profilePage.openProfile()
            profilePage.deleteCategory(categoryName)

            // Ждем обновления
            sleep(1)

            profilePage.assertCategoryDoesNotExist(categoryName)
            profilePage.closeProfile()
        }
    }

    private func verifyDeletedCategoryNotAvailableInNewSpend(categoryName: String) {
        XCTContext.runActivity(named: "Проверка: Удаленная категория недоступна при создании траты") { _ in
            spendsPage.addSpent()

            // Открываем меню выбора категории
            app.buttons["Select category"].tap()

            // Проверяем, что удаленной категории нет в списке
            let deletedCategoryButton = app.buttons[categoryName]
            let exists = deletedCategoryButton.waitForExistence(timeout: 2)

            XCTAssertFalse(exists,
                          "❌ Удаленная категория '\(categoryName)' все еще доступна в меню выбора категорий")

            // Закрываем меню (нажимаем в любое место вне меню)
            app.tap()
        }
    }
}
