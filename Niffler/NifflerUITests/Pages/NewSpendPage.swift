import XCTest

class NewSpendPage: BasePage {

    // MARK: - UI Elements

    private var amountField: XCUIElement {
        app.textFields["amountField"]
    }

    private var selectCategoryButton: XCUIElement {
        app.buttons["Select category"]
    }

    private var newCategoryButton: XCUIElement {
        app.buttons["+ New category"]
    }

    private var descriptionField: XCUIElement {
        app.textFields["descriptionField"]
    }

    private var addButton: XCUIElement {
        app.buttons["Add"]
    }

    private var categoryNameAlertField: XCUIElement {
        app.alerts.textFields.firstMatch
    }

    private var alertAddButton: XCUIElement {
        app.alerts.buttons["Add"]
    }

    // MARK: - Actions

    @discardableResult
    func inputAmount(_ amount: String = "14") -> Self {
        XCTContext.runActivity(named: "Шаг: Ввод суммы '\(amount)'") { _ in
            amountField.tap()
            amountField.typeText(amount)
        }
        return self
    }

    @discardableResult
    func selectCategory(_ categoryName: String = "Рыбалка") -> Self {
        XCTContext.runActivity(named: "Шаг: Выбор категории '\(categoryName)'") { _ in
            openCategoryMenu()
            app.buttons[categoryName].tap()
        }
        return self
    }

    @discardableResult
    private func openCategoryMenu() -> Self {
        selectCategoryButton.tap()
        return self
    }

    @discardableResult
    private func createNewCategory(_ categoryName: String) -> Self {
        XCTContext.runActivity(named: "Создание новой категории '\(categoryName)'") { _ in
            newCategoryButton.tap()
            categoryNameAlertField.tap()
            categoryNameAlertField.typeText(categoryName)
            alertAddButton.tap()
        }
        return self
    }

    @discardableResult
    func selectOrCreateCategory(_ categoryName: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Выбор/создание категории '\(categoryName)'") { _ in
            openCategoryMenu()

            let existingCategory = app.buttons[categoryName]
            if existingCategory.exists {
                existingCategory.tap()
            } else {
                createNewCategory(categoryName)
            }
        }
        return self
    }

    @discardableResult
    func inputDescription(_ description: String) -> Self {
        XCTContext.runActivity(named: "Шаг: Ввод описания '\(description)'") { _ in
            descriptionField.tap()
            descriptionField.typeText(description)
        }
        return self
    }

    @discardableResult
    func submit() -> Self {
        XCTContext.runActivity(named: "Шаг: Нажатие кнопки Add") { _ in
            addButton.tap()
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

}
