import XCTest

final class SignupUITests: TestCase {

    // MARK: - Test: Успешная регистрация нового пользователя

    func test_createNewAccount() throws {
        XCTContext.runActivity(named: "Тест: Создание нового аккаунта") { _ in
            // Arrange
            prepareAppForTesting()
            let testCredentials = generateUniqueCredentials()

            // Act
            performSignup(with: testCredentials)

            // Assert
            verifySignupSuccess()
        }
    }

    // MARK: - Test: Перенос данных с экрана логина на экран регистрации

    func test_dataTransferFromLoginToSignup() throws {
        XCTContext.runActivity(named: "Тест: Перенос данных с логина на регистрацию") { _ in
            // Arrange
            prepareAppForTesting()
            let testCredentials = TestCredentials(username: "testuser", password: "testpassword")

            // Act
            fillLoginFormWithoutSubmit(with: testCredentials)
            navigateToSignupPage()

            // Assert
            verifyDataTransferredToSignup(expectedCredentials: testCredentials)
        }
    }

    // MARK: - Helper Methods

    private func prepareAppForTesting() {
        XCTContext.runActivity(named: "Подготовка: Запуск приложения без авторизации") { _ in
            launchAppWithoutLogin()
        }
    }

    private func generateUniqueCredentials() -> TestCredentials {
        XCTContext.runActivity(named: "Подготовка: Генерация уникальных учетных данных") { _ in
            let username = "testuser_\(UUID().uuidString.prefix(8))"
            let password = "TestPassword123"
            return TestCredentials(username: username, password: password)
        }
    }

    private func performSignup(with credentials: TestCredentials) {
        XCTContext.runActivity(named: "Действие: Выполнение регистрации пользователя '\(credentials.username)'") { _ in
            signupPage
                .openSignupPage()
                .input(login: credentials.username,
                       password: credentials.password,
                       confirmPassword: credentials.password)
        }
    }

    private func verifySignupSuccess() {
        XCTContext.runActivity(named: "Проверка: Появление уведомления об успешной регистрации") { _ in
            signupPage.assertIsSignUpSuccessAlertShown()
        }
    }

    private func fillLoginFormWithoutSubmit(with credentials: TestCredentials) {
        XCTContext.runActivity(named: "Действие: Заполнение формы логина (логин: '\(credentials.username)')") { _ in
            loginPage.input(login: credentials.username)
            loginPage.input(password: credentials.password)
        }
    }

    private func navigateToSignupPage() {
        XCTContext.runActivity(named: "Действие: Переход на экран регистрации") { _ in
            signupPage.openSignupPage()
        }
    }

    private func verifyDataTransferredToSignup(expectedCredentials: TestCredentials) {
        XCTContext.runActivity(named: "Проверка: Данные перенесены на экран регистрации") { _ in
            let actualUsername = signupPage.getUsername()
            let actualPassword = signupPage.getPassword()

            XCTAssertEqual(actualUsername, expectedCredentials.username,
                          "Логин не перенесся на экран регистрации. Ожидалось: '\(expectedCredentials.username)', получено: '\(actualUsername)'")
            XCTAssertEqual(actualPassword, expectedCredentials.password,
                          "Пароль не перенесся на экран регистрации")
        }
    }
}

// MARK: - Test Data Models

private struct TestCredentials {
    let username: String
    let password: String
}
