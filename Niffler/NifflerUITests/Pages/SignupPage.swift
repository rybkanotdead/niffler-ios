import XCTest

class SignupPage: BasePage {

    // MARK: - Navigation

    @discardableResult
    func openSignupPage() -> Self {
        XCTContext.runActivity(named: "Шаг: Нажатие на кнопку 'Create new account'") { _ in
            app.staticTexts["Create new account"].tap()
        }
        return self
    }

    // MARK: - Registration Actions

    @discardableResult
    func input(login: String, password: String, confirmPassword: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Заполнение формы регистрации для пользователя '\(login)'") { _ in
            inputLogin(login)
            inputPassword(password)
            inputConfirmPassword(confirmPassword)
            pressSignUpButton()
        }
        return self
    }

    // MARK: - Private Input Methods

    private func inputLogin(_ login: String) {
        XCTContext.runActivity(named: "  → Ввод логина: '\(login)'") { _ in
            let loginField = app.textFields["userNameTextField"]
            loginField.tap()
            loginField.typeText(login)
        }
    }

    private func inputPassword(_ password: String) {
        XCTContext.runActivity(named: "  → Ввод пароля") { _ in
            let passwordField = app.secureTextFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(password)
        }
    }

    private func inputConfirmPassword(_ confirmPassword: String) {
        XCTContext.runActivity(named: "  → Подтверждение пароля") { _ in
            let confirmField = app.secureTextFields["confirmPasswordTextField"]
            confirmField.tap()
            confirmField.typeText(confirmPassword)
        }
    }

    private func pressSignUpButton() {
        XCTContext.runActivity(named: "  → Нажатие на кнопку 'Sign Up'") { _ in
            app.buttons["Sign Up"].tap()
        }
    }

    // MARK: - Assertions

    func assertIsSignUpSuccessAlertShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка: Отображение alert 'Congratulations!'") { _ in
            let alert = app.alerts["Congratulations!"]
            let isFound = alert.waitForExistence(timeout: 5)

            XCTAssertTrue(isFound,
                          "❌ Alert об успешной регистрации не найден",
                          file: file, line: line)
        }
    }

    // MARK: - Data Retrieval

    func getUsername() -> String {
        XCTContext.runActivity(named: "Получение значения поля Username") { _ in
            return app.textFields["userNameTextField"].value as? String ?? ""
        }
    }

    func getPassword() -> String {
        XCTContext.runActivity(named: "Получение значения поля Password") { _ in
            return app.secureTextFields["passwordTextField"].value as? String ?? ""
        }
    }
}
