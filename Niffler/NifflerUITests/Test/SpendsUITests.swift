import XCTest

final class SpendsUITests: TestCase {

    // MARK: - Add Spend Tests

    func test_addSpend_shouldShowInList() {
        XCTContext.runActivity(named: "Тест: Добавление траты отображается в списке") { _ in
            // Arrange
            launchAppWithoutLogin()
            let spendDescription = "Трата_\(UUID.randomPart)"

            loginPage
                .login(username: "stage", password: "12345")

            // Act
            spendsPage
                .waitForSpendsScreen()
                .openAddSpendForm()

            newSpendPage
                .createSpend(description: spendDescription)

            // Assert
            spendsPage
                .assertSpendIsShown(spendDescription)
        }
    }
}

// MARK: - Helper Extensions

extension UUID {
    static var randomPart: String {
        UUID().uuidString.components(separatedBy: "-").first!
    }
}
