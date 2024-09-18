import Foundation
//: [День 10](@previous) | [Содержание](Home) | [Контрольная точка 5](@next)
/*:
 # День 11: Структуры (Часть 2)

 ## Как ограничить доступ к внутренним данным с помощью контроля доступа

 По умолчанию Swift разрешает работать со всеми свойствами и методами структур. Но часто возникает необходимость ограничить видимость переменной или метода во избежание неблагоприятных исходов

 Посмотрим пример на основе счёта в банке
 */

struct BankAccount {
	var funds = 0

	mutating func deposit(amount: Int) {
		funds += amount
	}

	mutating func withdraw(amount: Int) -> Bool {
		if funds > amount {
			funds -= amount
			return true
		}

		return false
	}
}

var myAccount = BankAccount()
myAccount.deposit(amount: 100)

let success = myAccount.withdraw(amount: 200)

if success {
	print("Вы сняли деньги")
} else {
	print("Что-то пошло не так")
}

myAccount.funds -= 1_000

/*:
 В данном примере возникает серьёзная проблема, что кто-то может избежать использования нашей специальной логики и напрямую снять со счёта больше денег, чем их есть. Для этого и существует контроль доступа, чтобы уменьшить количество ошибок в коде. Есть множество различных вариаций, но самыми популярными являются:

 1. `private` - полностью запрещает доступ извне объекта.
 2. `fileprivate` - запрещает доступ вне текущего файла
 3. `public` - разрешает доступ из любого места. В большинстве случаев это исходное значение для всех свойств и методов
 4. `private(set)` - позволяет объектам изнутри читать значение, но изменение может происходить строго изнутри

 Для нашего счёта в банке идеально подойдёт `private(set)`, так как мы хотим, чтобы пользователь видел свой текущий счёт, но для взаимодействия использовал наши методы. В итоге `funds` будет выглядеть так:

	`private(set) var funds = 0`

 - Note:
 Зачастую, когда у нас есть незаполненные поля с уровнем доступа `private`, необходимо создать свой инициализатор

 ---

 ## Статические свойства и методы

 До этого момента мы рассматривали внутренние свойства и методы, которые относятся к экземплярам структуры. Бывают случаи, когда нам необходимо закрепить какой-то функционал или данные за самим объектом. Для этой задачи были создано ключевое слово `static`. Оно помечает свойство или метод как относящееся ко всему объекта, а не к конкретному экземпляру. Подобные вещи полезны, например, для создания шаблонных данных или для объявления какой-то константы, которая нужна и вне объекта

 Рассмотрим простейший пример
*/

struct School {
	static var studentCount = 0 // Количество учеников в школе

	static func add(student: String) {
		print("Добро пожаловать в школу, \(student)")
		studentCount += 1
	}
}

School.add(student: "Полина Гагарина")
print(School.studentCount)

/*:
 В отличии от обычных методов, статические не требуют пометки `mutating`, если они изменяют данные структуры, потому что они меняют свойства, относящиеся ко все структуре, а не к конкретной.

 А что если мы хотим модифицировать данные конкретного экземпляра из статических методов? Такого сделать нельзя. Даже если подумать логически, как это должно происходить, если мы не можем обратиться напрямую к конкретной реализации? Только если экземпляр объекта был передан нам в параметрах статической функции

 В обратную сторону, однако, общаться можно. Мы можем, как в примере выше про школу, обратиться из обычного метода к количеству учеников через `School.studentCount`. Но есть и другая форма. Поскольку мы находимся внутри объекта, мы можем сказать `Self.studentCount`. Особый акцент на большой букве S. В точности как мы пишем названия структур, перечислений или любых других типов данных начиная с большой буквы, а свойства, переменные и константы с маленькой, такое же правило относится и к `Self`/`self`:

 - `self` - обращение к _значению_ объекта
 - `Self` - обращение к _типу_ объекта

 Если само существование статических свойств и методов вызывает вопросы, рассмотрим пример наглядней. У нас может быть структура, где мы храним основные данные о приложении, как версия, имя файла для сохранения настроек и т.п.
 */

struct AppData {
	static let version = "1.3 beta 2"
	static let saveFileName = "settings.json"
	static let sourceURL = "https://www.hackingwithswift.com"
}

AppData.sourceURL

/*:
 Или мы хотим создать какой-то экран в приложении. Xcode в комбинации со SwiftUI создаёт предварительный просмотр на лету, пока мы пишем код и в таких случаях удобно иметь в модели Сотрудника, например, статическую константу с готовыми заполненными свойствами. Нам не придётся пересоздавать эти данные для каждого экарна, где мы будем использовать сотрудников
 */

struct Employee {
	static let example = Employee(username: "cfederighi", password: "h4irf0rce0ne")

	let username: String
	let password: String
}

let example = Employee.example

example.username

/*:
 - Note:
 Мы не можем объявить наш `example` обычным свойством, так как это вызовет бесконечный цикл создания примеров, потому что каждый сотрудник будет содержать пример, а тот в свою очередь будет содержать свой пример и т.д. Для удобства использования, мы объявляем `example` как статическое поле и мы можем использовать его повсеместно в нашей программе и мы всегда буем знать, что это пример именно Employee`
 */
 //: [День 10](@previous) | [Содержание](Home) | [Контрольная точка 5](@next)
