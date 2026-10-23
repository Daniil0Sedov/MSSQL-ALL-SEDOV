# Тема 7 · Контролируемая таблица заявок

**Презентация:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/07-google-sheets-leads/index.html

**Материалы и код:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/07-google-sheets-leads/materials.html

**Файлы занятия:** [materials/tema-07-google-sheets-leads](../materials/tema-07-google-sheets-leads/) —
приёмник `Code.gs`, фрагмент формы `form.html`, обработчик `lead-form.js`,
пошаговая практика.

**Задание в репозитории:** [`lesson_05`](../lesson_05/README.md) — форма сайта
пишет заявки в Google Таблицу через Apps Script.

## Содержание лекции

### Событие и заявка

После темы 6 при отправке формы в GA4 уходит событие `generate_lead`. В событии
нет имени и контакта, по нему нельзя связаться с человеком. Поэтому заявка
сохраняется отдельной строкой в таблице. Событие и строка таблицы
не зависят друг от друга, их проверяют в разных местах.

### Модель заявки

Таблица «GA4 Analytics Lab — Leads», лист `leads`, девять столбцов:

| Столбец | Что хранит | Кто заполняет |
|---|---|---|
| `request_id` | уникальный идентификатор заявки (UUID) | браузер, сервер проверяет формат |
| `created_at` | время записи | сервер |
| `name`, `email` | данные человека | форма |
| `direction` | выбранное направление | форма |
| `utm_source`, `utm_medium`, `utm_campaign` | источник перехода | скрытые поля формы |
| `status` | этап обработки, при записи всегда `new` | сервер |

В таблице настроены проверки ручного ввода: строка заголовков закреплена, в столбце
`status` выпадающий список `new`, `in_progress`, `done`, `rejected`,
условное форматирование подсвечивает пустые обязательные поля и дубли.
При заходе без меток в столбцы UTM пишутся `direct`, `none`, `not_set`.

### Приёмник на Apps Script

Apps Script — язык сценариев Google на JavaScript, встроенный в Таблицы.
Функция `doPost(e)` принимает POST-запрос формы. Проект публикуется как
**Web app**; адрес, оканчивающийся на `/exec`, ставится в `action` формы.

Что делает приёмник:

1. Открывает таблицу по ID через `SpreadsheetApp.openById`.
2. Проверяет обязательные поля, формат email, направление, формат UUID.
3. Берёт блокировку `ScriptLock`, чтобы две одновременные заявки
   не записались с ошибкой, и снимает её в блоке `finally`.
4. Ищет строку с тем же `request_id`: повторная отправка не создаёт дубль.
5. Экранирует текст, начинающийся с `=`, чтобы он не выполнился как формула.
6. Ставит время и статус `new`; статус из браузера игнорируется.

После изменения кода нужно обновить версию развёртывания Web app: простого
сохранения недостаточно.

### Форма на сайте

Форма в `contacts.html` отправляет POST в приёмник через скрытый `iframe`,
поэтому страница не перезагружается. Старый обработчик `submit` заменяется
новым: два обработчика с `preventDefault` остановят отправку. Код обёрнут
в функцию, чтобы не конфликтовать с переменными из `metrics.js`.

## Что делали на занятии

1. Создали таблицу, лист `leads`, девять заголовков, выпадающий список
   статусов и два правила подсветки.
2. Вставили `Code.gs` в Apps Script, указали ID своей таблицы, опубликовали
   Web app.
3. Заменили форму в `contacts.html` фрагментом `form.html`, обработчик —
   `lead-form.js`; опубликовали сайт через Commit → Push → Ready.
4. Отправили заявку без меток (`direct / none / not_set`) и с метками
   `utm_campaign=lesson07`, сверили строки в таблице.
5. Проверили ограничения: пустое имя не отправляется, повтор с тем же ID не даёт
   новой строки, неверный статус отклоняется, копия строки подсвечивается.
6. Перевели заявку `new → in_progress → done`.

## Что вошло в проект

- Таблица заявок `leads` и опубликованный приёмник Apps Script.
- Форма сайта пишет заявки вместе с UTM-метками.
- Эта таблица используется в темах 9 (заявка из Instagram), 10 (сверка
  с GA4) и 10.2 (вкладка заявок в DataLens).

## Документация

- [Apps Script: Web Apps](https://developers.google.com/apps-script/guides/web)
- [Доступ к связанным файлам из Web App](https://developers.google.com/apps-script/guides/bound)
- [LockService и ScriptLock](https://developers.google.com/apps-script/reference/lock/lock-service)
- [Sheet: appendRow и другие методы](https://developers.google.com/apps-script/reference/spreadsheet/sheet)
- [Content Service: ответ в формате JSON](https://developers.google.com/apps-script/guides/content)
