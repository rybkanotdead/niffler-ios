import XCTest

class ProfileSteps: BaseSteps {

    func getInitialCategoriesCount() -> Int {
        XCTContext.runActivity(named: "Шаг: Получение начального количества категорий") { _ in
            profilePage.openProfile()
            let count = profilePage.getCategoriesList().count
            profilePage.closeProfile()
            return count
        }
    }

    func verifyNewCategoryAddedToProfile(categoryName: String, expectedCount: Int) {
        XCTContext.runActivity(named: "Проверка: Новая категория добавлена в профиль") { _ in
            profilePage.openProfile()
            profilePage.assertCategoryExists(categoryName)
            profilePage.assertCategoriesCount(expectedCount)
            profilePage.closeProfile()
        }
    }

    func deleteCategoryFromProfile(categoryName: String) {
        XCTContext.runActivity(named: "Действие: Удаление категории '\(categoryName)' из профиля") { _ in
            profilePage.openProfile()
            profilePage.deleteCategory(categoryName)

            // Ждем обновления
            sleep(1)

            profilePage.assertCategoryDoesNotExist(categoryName)
            profilePage.closeProfile()
        }
    }

    func verifyDeletedCategoryNotAvailableInNewSpend(categoryName: String) {
        XCTContext.runActivity(named: "Проверка: Удаленная категория недоступна при создании траты") { _ in
            spendsPage.addSpent()

            // Открываем меню выбора категории
            app.buttons["Select category"].tap()

            // Проверяем, что удаленной категории нет в списке
            let deletedCategoryButton = app.buttons[categoryName]
            let exists = deletedCategoryButton.waitForExistence(timeout: 2)

            XCTAssertFalse(exists,
                          "Удаленная категория '\(categoryName)' все еще доступна в меню выбора категорий")

            // Закрываем меню (нажимаем в любое место вне меню)
            app.tap()
        }
    }
}

