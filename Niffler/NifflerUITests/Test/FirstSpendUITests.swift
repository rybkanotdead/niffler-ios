import XCTest

final class FirstSpendUITests: TestCase {

    // MARK: - Test: Добавление первой траты для нового пользователя

    func test_addFirstSpendForNewUser() throws {
        XCTContext.runActivity(named: "Тест: Добавление первой траты для нового аккаунта") { _ in
            // Arrange
            prepareAppForTesting()
            let credentials = registerNewUser()
            loginAsNewUser(credentials: credentials)

            // Act
            verifyEmptySpendsList()
            addFirstSpend()

            // Assert
            verifyFirstSpendAdded()
        }
    }

    // MARK: - Helper Methods

    private func prepareAppForTesting() {
        XCTContext.runActivity(named: "Подготовка: Запуск приложения") { _ in
            launchAppWithoutLogin()
        }
    }

    private func registerNewUser() -> TestCredentials {
        XCTContext.runActivity(named: "Подготовка: Регистрация нового пользователя") { _ in
            let username = "newuser_\(UUID().uuidString.prefix(8))"
            let password = "TestPassword123"

            // Переходим на экран регистрации
            app.staticTexts["Create new account"].tap()

            // Регистрируем пользователя
            let usernameField = app.textFields["userNameTextField"]
            usernameField.tap()
            usernameField.typeText(username)

            let passwordField = app.secureTextFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(password)

            let confirmPasswordField = app.secureTextFields["confirmPasswordTextField"]
            confirmPasswordField.tap()
            confirmPasswordField.typeText(password)

            app.buttons["Sign Up"].tap()

            // Ждем alert об успешной регистрации
            let alert = app.alerts["Congratulations!"]
            _ = alert.waitForExistence(timeout: 5)

            return TestCredentials(username: username, password: password)
        }
    }

    private func loginAsNewUser(credentials: TestCredentials) {
        XCTContext.runActivity(named: "Действие: Вход в систему как '\(credentials.username)'") { _ in
            // Закрываем alert регистрации
            app.alerts.buttons["Log in"].tap()

            // Авторизуемся
            let usernameField = app.textFields["userNameTextField"]
            usernameField.tap()
            usernameField.tap()
            usernameField.typeText(credentials.username)

            let passwordField = app.secureTextFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(credentials.password)

            app.buttons["loginButton"].tap()
        }
    }

    private func verifyEmptySpendsList() {
        XCTContext.runActivity(named: "Проверка: Список трат пустой") { _ in
            spendsPage.assertIsEmptySpendsList()
        }
    }

    private func addFirstSpend() {
        XCTContext.runActivity(named: "Действие: Добавление первой траты") { _ in
            spendsPage.addSpent()
            newSpendPage.inputSpentWithNewCategory(title: "Первая трата", categoryName: "Продукты")
        }
    }

    private func verifyFirstSpendAdded() {
        XCTContext.runActivity(named: "Проверка: Трата успешно добавлена") { _ in
            spendsPage.assertNewSpendIsShown(title: "Первая трата")
        }
    }
}

// MARK: - Test Data Models

private struct TestCredentials {
    let username: String
    let password: String
}
