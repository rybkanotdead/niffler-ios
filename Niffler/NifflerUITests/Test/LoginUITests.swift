import XCTest

final class LoginUITests: TestCase {

    // MARK: - Successful Login Tests

    func test_loginSuccess() throws {
        XCTContext.runActivity(named: "Тест: Успешная авторизация") { _ in
            // Arrange
            launchAppWithoutLogin()

            // Act & Assert
            loginPage
                .login(username: "stage", password: "12345")

            spendsPage
                .waitForSpendsScreen()
                .assertSpendsViewAppeared()

            loginPage
                .assertNoErrorShown()
        }
    }

    // MARK: - Failed Login Tests

    func test_loginFailure() throws {
        XCTContext.runActivity(named: "Тест: Неудачная авторизация с неверным паролем") { _ in
            // Arrange
            launchAppWithoutLogin()

            // Act & Assert
            loginPage
                .login(username: "stage", password: "wrongpassword")
                .assertLoginErrorShown()
        }
    }
}
