import XCTest

class NewSpendPage: BasePage {

    // MARK: - Actions

    @discardableResult
    func inputAmount(_ amount: String = "14") -> Self {
        XCTContext.runActivity(named: "Шаг: Ввод суммы '\(amount)'") { _ in
            let amountField = app.textFields["amountField"]
            amountField.tap()
            amountField.typeText(amount)
        }
        return self
    }

    @discardableResult
    func selectCategory(_ categoryName: String = "Рыбалка") -> Self {
        XCTContext.runActivity(named: "Шаг: Выбор категории '\(categoryName)'") { _ in
            app.buttons["Select category"].tap()
            app.buttons[categoryName].tap()
        }
        return self
    }

    @discardableResult
    func selectOrCreateCategory(_ categoryName: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Выбор/создание категории '\(categoryName)'") { _ in
            let categoryButton = app.buttons["Select category"]
            categoryButton.tap()

            let newCategoryButton = app.buttons["+ New category"]

            if newCategoryButton.exists {
                XCTContext.runActivity(named: "  → Создание новой категории") { _ in
                    newCategoryButton.tap()
                    let categoryNameField = app.alerts.textFields.firstMatch
                    categoryNameField.tap()
                    categoryNameField.typeText(categoryName)
                    app.alerts.buttons["Add"].tap()
                }
            } else {
                let existingCategory = app.buttons[categoryName]
                if existingCategory.exists {
                    XCTContext.runActivity(named: "  → Выбор существующей категории") { _ in
                        existingCategory.tap()
                    }
                } else {
                    XCTContext.runActivity(named: "  → Создание категории через меню") { _ in
                        app.buttons["+ New category"].tap()
                        let categoryNameField = app.alerts.textFields.firstMatch
                        categoryNameField.tap()
                        categoryNameField.typeText(categoryName)
                        app.alerts.buttons["Add"].tap()
                    }
                }
            }
        }
        return self
    }

    @discardableResult
    func inputDescription(_ description: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Ввод описания '\(description)'") { _ in
            let descriptionField = app.textFields["descriptionField"]
            descriptionField.tap()
            descriptionField.typeText(description)
        }
        return self
    }

    @discardableResult
    func submit() -> Self {
        XCTContext.runActivity(named: "Шаг: Нажатие кнопки Add") { _ in
            app.buttons["Add"].tap()
        }
        return self
    }

    // MARK: - High-level actions

    @discardableResult
    func createSpend(amount: String = "14", category: String = "Рыбалка", description: String) -> Self {
        XCTContext.runActivity(named: "Действие: Создание траты '\(description)'") { _ in
            inputAmount(amount)
                .selectCategory(category)
                .inputDescription(description)
                .submit()
        }
        return self
    }

    @discardableResult
    func createSpendWithNewCategory(amount: String = "14", categoryName: String, description: String) -> Self {
        XCTContext.runActivity(named: "Действие: Создание траты с новой категорией '\(categoryName)'") { _ in
            inputAmount(amount)
                .selectOrCreateCategory(categoryName)
                .inputDescription(description)
                .submit()
        }
        return self
    }

    // MARK: - Legacy compatibility methods (deprecated)

    @available(*, deprecated, renamed: "submit")
    func pressAddSpend() {
        submit()
    }

    @available(*, deprecated, renamed: "createSpend")
    func inputSpent(title: String) {
        createSpend(description: title)
    }

    @available(*, deprecated, renamed: "createSpendWithNewCategory")
    func inputSpentWithNewCategory(title: String, categoryName: String) {
        createSpendWithNewCategory(categoryName: categoryName, description: title)
    }
}
