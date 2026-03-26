import XCTest

final class CategoryManagementUITests: TestCase {

    func test_categoryAppearsInProfileAfterAddingSpend() throws {
        XCTContext.runActivity(named: "Тест: Категория появляется в профиле после добавления траты") { _ in
            // Arrange - объявляем тестовые данные в начале теста
            let newCategoryName = "ТестоваяКатегория_\(UUID().uuidString.prefix(6))"
            let spendTitle = "Тестовая трата"

            baseSteps.prepareTestEnvironment()
            let initialCategoriesCount = profileSteps.getInitialCategoriesCount()

            // Act
            spendSteps.addSpendWithNewCategory(
                title: spendTitle,
                categoryName: newCategoryName
            )

            // Assert
            profileSteps.verifyNewCategoryAddedToProfile(
                categoryName: newCategoryName,
                expectedCount: initialCategoriesCount + 1
            )
        }
    }

    func test_deletedCategoryDoesNotAppearInNewSpend() throws {
        XCTContext.runActivity(named: "Тест: Удаленная категория не появляется при создании траты") { _ in
            // Arrange - объявляем тестовые данные в начале теста
            let categoryToDelete = "Рыбалка"

            baseSteps.prepareTestEnvironment()

            // Act
            profileSteps.deleteCategoryFromProfile(categoryName: categoryToDelete)

            // Assert
            profileSteps.verifyDeletedCategoryNotAvailableInNewSpend(categoryName: categoryToDelete)
        }
    }
}

