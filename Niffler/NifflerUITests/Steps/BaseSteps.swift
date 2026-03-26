import XCTest

class BaseSteps {
    let app: XCUIApplication
    let loginPage: LoginPage
    let spendsPage: SpendsPage
    let newSpendPage: NewSpendPage
    let profilePage: ProfilePage

    init(app: XCUIApplication,
         loginPage: LoginPage,
         spendsPage: SpendsPage,
         newSpendPage: NewSpendPage,
         profilePage: ProfilePage) {
        self.app = app
        self.loginPage = loginPage
        self.spendsPage = spendsPage
        self.newSpendPage = newSpendPage
        self.profilePage = profilePage
    }

    func prepareTestEnvironment() {
        XCTContext.runActivity(named: "Подготовка: Запуск и авторизация") { _ in
            launchAppWithoutLogin()
            loginPage.input(login: "stage", password: "12345")
            spendsPage.waitSpendsScreen()
        }
    }

    func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запускаю приложение в режиме 'без авторизации'") { _ in
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
}

