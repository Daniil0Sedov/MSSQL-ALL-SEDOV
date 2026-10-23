# Тема 9 · Instagram → ManyChat → заявка

**Презентация:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/09-instagram-manychat/index.html

**Материалы и тексты для копирования:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/09-instagram-manychat/materials.html

**Файлы занятия:** [materials/tema-09-instagram-manychat](../materials/tema-09-instagram-manychat/) —
страница `guide.html` с кодом `guide.js`, тексты сообщений, список проверок.

**Задание в репозитории:** [`lesson_07`](../lesson_07/README.md) — цепочка
Instagram → ManyChat → сайт → заявка в таблице.

## Содержание лекции

### Автоворонка из соцсети

Человек оставляет под публикацией комментарий с ключевым словом и получает
в личные сообщения ссылку на материал. С материала он переходит на форму
и оставляет заявку. Ответы и ссылки отправляются автоматически.

```text
комментарий «ГАЙД» под публикацией
↓
публичный ответ и личное сообщение от ManyChat
↓
кнопка Open Website → guide.html с UTM-метками
↓
кнопка к форме → contacts.html с теми же метками
↓
событие generate_lead в GA4 и строка в листе leads
```

### ManyChat

ManyChat — сервис автоматизации переписки в Instagram, Facebook Messenger
и других каналах. Автоматизация строится по схеме **Trigger → Condition →
Action**: что запускает, при каком условии, что делать.

| Элемент | Значение в практике |
|---|---|
| Trigger | комментарий под конкретной публикацией (Specific Post) |
| Condition | комментарий содержит слово «ГАЙД» |
| Public Reply | публичный ответ под комментарием |
| Private Reply | личное сообщение автору комментария с кнопкой Open Website |

Для подключения нужен профессиональный аккаунт Instagram. Практика
выполняется на тарифе Free. Private Reply отправляется на первый
комментарий человека под публикацией: повторный комментарий того же
пользователя новую проверку не запускает. Нажатие кнопки Open Website
в первом сообщении не даёт права отправить человеку следующее личное
сообщение: для этого нужна обычная кнопка ответа.

### Метки и аналитика

Ссылка в сообщении содержит четыре метки: `utm_source=instagram`,
`utm_medium=social`, `utm_campaign=backend_guide`, `utm_content=reel01`. Страница
`guide.html` переносит их на `contacts.html`. Форма сохраняет в таблицу
`source`, `medium`, `campaign`; `utm_content` остаётся в адресе и в GA4.

В GA4 различают **First user source** (откуда человек пришёл впервые)
и **Session source** (откуда начался текущий сеанс). Новая метка в адресе
сама не начинает новый сеанс. Событие `generate_lead` отправляется при
отправке формы, поэтому запись заявки проверяют отдельно — по строке
в таблице.

## Что делали на занятии

1. Скопировали `guide.html` и `guide.js` в репозиторий своего сайта,
   заменили Measurement ID, опубликовали.
2. Проверили, что метки доходят с `guide.html` до формы.
3. Подключили профессиональный аккаунт Instagram к ManyChat, опубликовали
   пост.
4. Настроили автоматизацию: Specific Post, слово «ГАЙД», Public Reply,
   Private Reply с кнопкой Open Website, тексты из `messages.md`.
5. Включили её (Preview → Set Live), отдельный пользователь оставил
   комментарий.
6. Прошли всю цепочку и нашли заявку в листе `leads` с источником
   `instagram`.

## Что вошло в проект

- Страница `guide.html` на сайте и автоматизация ManyChat.
- Заявки с `utm_source=instagram`, `utm_campaign=backend_guide` — на них
  строится анализ кампании в теме 10 и фильтры отчёта в теме 10.2.

## Документация

- [ManyChat: триггер на комментарии под Post и Reel](https://help.manychat.com/hc/en-us/articles/14281316989724-Instagram-Post-and-Reel-Comments-Trigger)
- [ManyChat: подключение Instagram](https://help.manychat.com/hc/en-us/articles/14281290924444-How-to-connect-Instagram-to-Manychat)
- [ManyChat: если Instagram не подключается](https://help.manychat.com/hc/en-us/articles/14281291094428-Can-t-connect-Instagram-to-Manychat)
- [ManyChat: тариф Free](https://help.manychat.com/hc/en-us/articles/25800197498652-Free-plan)
- [GA4: области действия источников](https://support.google.com/analytics/answer/11080067?hl=en)
- [GA4: UTM и сеанс](https://support.google.com/analytics/answer/11242841?hl=en)
- [GA4: Enhanced measurement](https://support.google.com/analytics/answer/9216061?hl=en)
