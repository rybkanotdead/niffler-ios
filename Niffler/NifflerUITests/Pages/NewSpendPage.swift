import XCTest

class NewSpendPage: BasePage {

    // MARK: - High-level Actions

    func inputSpent(title: String) {
        inputAmount()
        .selectCategory()
        .inputDescription(title)
        .pressAddSpend()
    }

    func inputSpentWithNewCategory(title: String, categoryName: String) {
        XCTContext.runActivity(named: "Шаг: Добавление траты с новой категорией '\(categoryName)'") { _ in
            inputAmount()
            .selectOrCreateCategory(categoryName)
            .inputDescription(title)
            .pressAddSpend()
        }
    }

    // MARK: - Individual Actions

    func inputAmount() -> Self {
        XCTContext.runActivity(named: "  → Ввод суммы траты") { _ in
            app.textFields["amountField"].typeText("14")
        }
        return self
    }

    func selectCategory() -> Self {
        XCTContext.runActivity(named: "  → Выбор существующей категории") { _ in
            app.buttons["Select category"].tap()
            app.buttons["Рыбалка"].tap()
        }
        return self
    }

    func selectOrCreateCategory(_ categoryName: String) -> Self {
        XCTContext.runActivity(named: "  → Выбор или создание категории '\(categoryName)'") { _ in
            let categoryButton = app.buttons["Select category"]
            categoryButton.tap()

            // Проверяем, есть ли кнопка "+ New category"
            let newCategoryButton = app.buttons["+ New category"]

            if newCategoryButton.exists {
                // Если кнопка "+ New category" есть, значит категорий нет - создаем новую
                XCTContext.runActivity(named: "    → Создание новой категории (список пуст)") { _ in
                    newCategoryButton.tap()
                    let categoryNameField = app.alerts.textFields.firstMatch
                    categoryNameField.tap()
                    categoryNameField.typeText(categoryName)
                    app.alerts.buttons["Add"].tap()
                }
            } else {
                // Если кнопки "+ New category" нет в корне, проверяем в меню
                let existingCategory = app.buttons[categoryName]
                if existingCategory.exists {
                    XCTContext.runActivity(named: "    → Выбор существующей категории") { _ in
                        existingCategory.tap()
                    }
                } else {
                    // Категория не найдена, создаем новую через меню
                    XCTContext.runActivity(named: "    → Создание новой категории через меню") { _ in
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

    func inputDescription(_ title: String) -> Self {
        XCTContext.runActivity(named: "  → Ввод описания: '\(title)'") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(title)
        }
        return self
    }

    func pressAddSpend() {
        XCTContext.runActivity(named: "  → Нажатие на кнопку 'Add'") { _ in
            app.buttons["Add"].tap()
        }
    }
}
