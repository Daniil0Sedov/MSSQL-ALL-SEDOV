# Тема 10 · GA4: отчёты и исследования

**Презентация:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/10-ga4-explorations/index.html

**Материалы:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/10-ga4-explorations/materials.html

**Файлы занятия:** [materials/tema-10-ga4-explorations](../materials/tema-10-ga4-explorations/) —
шаблон анализа, чек-лист, таблица соответствия полей.

## Содержание лекции

После тем 5–9 в ресурсе GA4 накопились данные своего сайта: просмотры,
клики, отправки формы, переходы из Instagram. В теме разобрано, как
по этим данным ответить на вопрос «где теряются люди и откуда приходят
заявки».

### Перед анализом

Записывают ресурс, часовой пояс, завершённый период и свои права доступа.
Период в Reports и в Explore задаётся отдельно. Стандартные отчёты
наполняются после обработки данных, обычно в течение суток.

### Reports — готовые отчёты

| Отчёт | Что показывает |
|---|---|
| Traffic acquisition | сеансы по Session source / medium и Session campaign |
| User acquisition | пользователей по источнику первого визита |
| Landing page | страницы, с которых начинались сеансы |
| Pages and screens | просмотры по страницам |
| Events | количество событий по имени |
| Tech | устройства, браузеры, операционные системы |

Сравнение периодов и сравнение групп (например, Instagram и direct)
включаются в шапке отчёта. Отчёт можно скачать в CSV или PDF.

### Explore — исследования

| Тип | Для чего |
|---|---|
| **Free form** | таблица из выбранных измерений и метрик с фильтрами и сегментами |
| **Сегмент** | подмножество данных: например, сеансы с `source=instagram`; группы могут пересекаться |
| **Funnel exploration** | воронка из шагов; показывает, сколько пользователей перешло с шага на шаг |
| **Path exploration** | дерево путей от выбранного события или к нему |

Базовая воронка темы: `session_start → cta_click → form_start →
generate_lead`, тип Closed, без ограничения времени. Пример расчёта
из лекции: 100 → 48 → 21 → 11. Больше всего людей теряется на первом
переходе (52 человека), по доле — между кнопкой и формой (56,25 %).
Funnel считает пользователей, сеансы в нём не считаются.

Фильтр `Event name = generate_lead`, наложенный на всю воронку или путь,
убирает предшествующие шаги, поэтому его ставят только в отдельной таблице.

### Атрибуция, Insights, Library

**Атрибуция** показывает, какие каналы участвовали в пути к ключевому
действию. **Insights** — автоматические и свои оповещения об изменениях
в данных. **Library** позволяет собрать свои отчёты и коллекции в меню.
Для создания Insights и настройки Library нужна роль Editor или
Administrator.

### Разные показатели

Sessions, пользователи воронки, Event count, Key events и сохранённые
заявки в таблице — разные числа. Отношение событий к сеансам не равно доле
сеансов с заявкой. Заявки из таблицы сверяют с GA4 отдельно, за тот же
период и с теми же source и campaign.

## Что делали на занятии

1. Проверили, что приходят четыре события воронки.
2. Записали условия анализа в `analysis-template.md`.
3. Прошли Reports: Traffic acquisition, Landing page, Pages and screens,
   Events, Tech; сравнили Instagram и direct.
4. Собрали Free form: таблица трафика и отдельная вкладка `generate_lead`.
5. Создали сегменты Instagram Sessions и Direct Sessions.
6. Построили Funnel из четырёх шагов, затем проверили режимы Open,
   Within 10 minutes и Breakdown.
7. Построили Path от кнопки и обратный путь к `generate_lead`.
8. Для итогового кейса `source=instagram`, `campaign=backend_guide`
   выгрузили результаты и записали наблюдение, ограничение, гипотезу
   и план проверки.

## Что вошло в проект

- Заполненный шаблон анализа с условиями, которые позволяют повторить
  расчёт.
- Выводы по кампании Instagram и сверка числа `generate_lead` с заявками
  в таблице.

## Документация

- [Области действия источников](https://support.google.com/analytics/answer/11080067?hl=en)
- [Explore: начало работы](https://support.google.com/analytics/answer/7579450?hl=en)
- [Funnel exploration](https://support.google.com/analytics/answer/9327974?hl=en)
- [Path exploration](https://support.google.com/analytics/answer/9317498?hl=en)
- [Создание сегментов](https://support.google.com/analytics/answer/9304353?hl=en)
- [Engagement rate](https://support.google.com/analytics/answer/12195621?hl=en)
- [Key event attribution paths](https://support.google.com/analytics/answer/10595568?hl=en)
- [Analytics Insights](https://support.google.com/analytics/answer/9443595?hl=en)
- [Создание detail report](https://support.google.com/analytics/answer/13844077?hl=en)
- [Коллекции и навигация](https://support.google.com/analytics/answer/10460557?hl=en)
