import XCTest

final class SpendsUITests: TestCase {
    
    func test_whenAddSpent_shouldShowSpendInList() {
        // Arrange - объявляем тестовые данные в начале теста
        let title = UUID.randomPart

        launchAppWithoutLogin()
        
        loginPage
            .input(login: "stage", password: "12345")
        
        // Act
        spendsPage
            .waitSpendsScreen()
            .addSpent()
        
        newSpendPage
            .inputSpent(title: title)
        
        // Assert
        spendsPage
            .assertNewSpendIsShown(title: title)
    }
}

extension UUID {
    static var randomPart: String {
        UUID().uuidString.components(separatedBy: "-").first!
    }
}
