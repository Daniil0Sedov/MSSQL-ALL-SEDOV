# Тема 6 · События и параметры GA4

**Презентация:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/06-ga4-events/index.html

**Материалы и код:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/06-ga4-events/materials.html

**Файлы занятия:** [materials/tema-06-ga4-events](../materials/tema-06-ga4-events/) —
пошаговая практика, сайт-пример из трёх страниц, готовые `index.html`,
`contacts.html` и `js/metrics.js`.

**Задание в репозитории:** [`lesson_04`](../lesson_04/README.md) — четыре своих
события и их параметры.

**Тест:** [Тест 2 · GA4, Google Tag и события](https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/tests/temy-4-6/index.html) — по темам 4, 5 и 6.

## Содержание лекции

### Событийная модель

В GA4 любое измерение — событие: имя плюс набор параметров. Просмотр
страницы — событие `page_view`, нажатие кнопки — событие с именем, которое
задаёт разработчик. Параметры уточняют событие: какая кнопка, в каком блоке
страницы, с какой формы.

### Автоматические измерения

Enhanced measurement собирает без кода:

| Событие | Когда срабатывает |
|---|---|
| `scroll` | прокрутка до 90 % страницы, один раз за просмотр |
| `click` | переход по ссылке на другой домен; внутренние ссылки не считаются |
| `file_download` | клик по ссылке на файл (PDF и др.); завершение скачивания не проверяется |
| `form_start`, `form_submit` | начало заполнения и отправка формы; распознавание формы нужно проверять |

### Собственные события

Свои события отправляются вызовом `gtag('event', имя, параметры)`.
На занятии добавили два:

```js
gtag('event', 'cta_click', { button_name: 'program', page_section: 'hero' });
gtag('event', 'generate_lead', { lead_source: 'contact_form' });
```

`generate_lead` — рекомендуемое имя Google для заявки. Здесь событие
отправляется после проверки формы в браузере; на реальном сайте его отправляют
после ответа сервера о сохранении заявки. Имя, email и телефон в параметры
события не передаются.

В курсе имена событий и параметров пишутся латиницей, строчными буквами,
через подчёркивание. GA4 ограничивает имя события 40 символами и не принимает
имена с зарезервированными приставками `ga_`, `google_`, `firebase_`.

### Проверка и настройка в GA4

| Инструмент | Для чего |
|---|---|
| **DebugView** | лента событий одного браузера в режиме отладки; включается через Google Tag Assistant или параметр `debug_mode: true` |
| **Custom Dimension** | регистрирует параметр события как разрез отчётов; например «Название кнопки» → `button_name`; данные появляются через 24–48 часов и только для новых событий |
| **Key Event** | отметка «это ключевое действие» на событии из списка; ставится на `generate_lead` на следующий день, когда событие появится в списке |

Чтобы выключить режим отладки, параметр `debug_mode` удаляют из кода:
значение `false` режим не выключает.

## Что делали на занятии

1. Проверили переключатели Enhanced measurement в настройках потока.
2. На своём сайте вызвали `scroll`, `click`, `file_download`, `form_start`,
   `form_submit` и нашли их в Realtime.
3. Добавили кнопку `program-cta` и обработчик `cta_click`.
4. Переименовали форму в `lead-form` и заменили старый обработчик `submit`
   новым, который отправляет `generate_lead`.
5. Опубликовали изменения и проверили оба события с параметрами в DebugView.
6. Создали Custom Dimension для `button_name` и отметили `generate_lead`
   как Key Event.

## Что вошло в проект

- На сайте работают `cta_click` и `generate_lead`.
- В задании 4 к ним добавляется файл `js/metrics.js` с четырьмя событиями:
  `nav_click`, `utm_visit`, `read_30s`, `form_error`.
- В GA4 зарегистрирован разрез «Название кнопки», `generate_lead` — ключевое
  действие. Эти события используются в темах 9, 10 и 10.2.

## Документация

- [Enhanced measurement](https://support.google.com/analytics/answer/9216061?hl=ru)
- [Рекомендуемые события: generate_lead](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#generate_lead)
- [DebugView](https://support.google.com/analytics/answer/7201382?hl=ru)
- [Custom Dimensions](https://support.google.com/analytics/answer/14240153?hl=ru)
- [Key Events](https://support.google.com/analytics/answer/13128484?hl=ru)
- [Правила имён событий](https://support.google.com/analytics/answer/13316687?hl=ru)
