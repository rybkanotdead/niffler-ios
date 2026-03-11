import XCTest

final class SignupUITests: TestCase {
    
    func test_createNewAccount() throws {
        launchAppWithoutLogin()
        
        // Arrange
        let username = "testuser_\(UUID().uuidString.prefix(8))"
        let password = "TestPassword123"
        
        // Act
        signupPage
            .openSignupPage()
            .input(login: username, password: password, confirmPassword: password)
        
        // Assert
        signupPage.assertIsSignUpSuccessAlertShown()
    }
    
    func test_dataTransferFromLoginToSignup() throws {
        launchAppWithoutLogin()
        
        // Arrange
        let username = "testuser"
        let password = "testpassword"
        
        // Act - вводим данные на экране логина
        loginPage.input(login: username)
        loginPage.input(password: password)
        
        // Открываем экран регистрации
        signupPage.openSignupPage()
        
        // Assert - проверяем, что данные перенеслись
        XCTContext.runActivity(named: "Проверяю, что логин и пароль перенеслись на экран регистрации") { _ in
            let signupUsername = signupPage.getUsername()
            let signupPassword = signupPage.getPassword()
            
            XCTAssertEqual(signupUsername, username, "Логин не перенесся на экран регистрации")
            XCTAssertEqual(signupPassword, password, "Пароль не перенесся на экран регистрации")
        }
    }
}
