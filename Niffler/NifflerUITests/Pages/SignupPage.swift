import XCTest

class SignupPage: BasePage {
    
    @discardableResult
    func openSignupPage() -> Self {
        XCTContext.runActivity(named: "Открываю экран регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
        return self
    }
    
    @discardableResult
    func input(login: String, password: String, confirmPassword: String) -> Self {
        XCTContext.runActivity(named: "Регистрирую пользователя \(login)") { _ in
            input(login: login)
            input(password: password)
            input(confirmPassword: confirmPassword)
            pressSignUpButton()
        }
        return self
    }
    
    private func input(login: String) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            app.textFields["userNameTextField"].tap()
            app.textFields["userNameTextField"].typeText(login)
        }
    }
    
    private func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            app.secureTextFields["passwordTextField"].tap()
            app.secureTextFields["passwordTextField"].typeText(password)
        }
    }
    
    private func input(confirmPassword: String) {
        XCTContext.runActivity(named: "Подтверждаю пароль \(confirmPassword)") { _ in
            app.secureTextFields["confirmPasswordTextField"].tap()
            app.secureTextFields["confirmPasswordTextField"].typeText(confirmPassword)
        }
    }
    
    private func pressSignUpButton() {
        XCTContext.runActivity(named: "Жму кнопку Sign Up") { _ in
            app.buttons["Sign Up"].tap()
        }
    }
    
    func assertIsSignUpSuccessAlertShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение об успешной регистрации") { _ in
            let alert = app.alerts["Congratulations!"]
            let isFound = alert.waitForExistence(timeout: 5)
            
            XCTAssertTrue(isFound,
                          "Не нашли сообщение об успешной регистрации",
                          file: file, line: line)
        }
    }
    
    func getUsername() -> String {
        return app.textFields["userNameTextField"].value as? String ?? ""
    }
    
    func getPassword() -> String {
        return app.secureTextFields["passwordTextField"].value as? String ?? ""
    }
}
