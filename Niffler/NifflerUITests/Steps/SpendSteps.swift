import XCTest

class SpendSteps: BaseSteps {

    func addSpendWithNewCategory(title: String, categoryName: String) {
        XCTContext.runActivity(named: "Действие: Добавление траты с категорией '\(categoryName)'") { _ in
            spendsPage.addSpent()
            newSpendPage.inputSpentWithNewCategory(title: title, categoryName: categoryName)

            // Ждем завершения добавления траты
            sleep(2)
        }
    }
}

