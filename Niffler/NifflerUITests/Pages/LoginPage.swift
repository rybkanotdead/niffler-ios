import XCTest

class LoginPage: BasePage {

    // MARK: - Actions

    @discardableResult
    func inputLogin(_ login: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Ввод логина '\(login)'") { _ in
            let loginField = app.textFields["userNameTextField"]
            loginField.tap()
            loginField.tap() // TODO: Remove the cause of double tap
            loginField.typeText(login)
        }
        return self
    }

    @discardableResult
    func inputPassword(_ password: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Ввод пароля") { _ in
            let passwordField = app.secureTextFields["passwordTextField"]
            passwordField.tap()
            passwordField.typeText(password)
        }
        return self
    }

    @discardableResult
    func pressLoginButton() -> Self {
        XCTContext.runActivity(named: "Шаг: Нажатие кнопки Login") { _ in
            app.buttons["loginButton"].tap()
        }
        return self
    }

    @discardableResult
    func login(username: String, password: String) -> Self {
        XCTContext.runActivity(named: "Действие: Авторизация '\(username)'") { _ in
            inputLogin(username)
                .inputPassword(password)
                .pressLoginButton()
        }
        return self
    }

    @discardableResult
    func openSignupPage() -> Self {
        XCTContext.runActivity(named: "Шаг: Открытие экрана регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
        return self
    }

    // MARK: - Assertions

    @discardableResult
    func assertLoginErrorShown(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Отображается ошибка входа") { _ in
            let isFound = app.staticTexts["LoginError"]
                .waitForExistence(timeout: 5)

            XCTAssertTrue(isFound,
                          "❌ Сообщение об ошибке входа не найдено",
                          file: file, line: line)
        }
        return self
    }

    @discardableResult
    func assertNoErrorShown(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка: Ошибка входа отсутствует") { _ in
            let errorLabel = app.staticTexts["LoginError"]
            let isFound = errorLabel.waitForExistence(timeout: 5)

            XCTAssertFalse(isFound,
                           "❌ Появилась ошибка: \(errorLabel.label)",
                          file: file, line: line)
        }
        return self
    }
}
