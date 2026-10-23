# Тема 5 · Свой сайт, Vercel и Google Tag

**Презентация:** https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/lessons/05-vercel-google-tag/index.html

**Шаблон сайта:** https://github.com/MaximBytecamp/ga4-analytics-lab

**Файлы занятия:** [materials/tema-05-vercel-google-tag](../materials/tema-05-vercel-google-tag/)

**Задание в репозитории:** [`lesson_03`](../lesson_03/README.md) — тег на сайте,
источник перехода и отчёты GA4.

**Тест:** [Тест 2 · GA4, Google Tag и события](https://algorthimization-course-vvodnoe.vercel.app/op03-informacionnye-tehnologii/tests/temy-4-6/index.html) — по темам 4, 5 и 6.

## Содержание лекции

### Копия шаблона и клонирование

Сайт для практики — шаблон `ga4-analytics-lab`: три страницы на HTML, CSS
и JavaScript без сборки. Кнопка **Use this template → Create a new repository**
создаёт личную копию на своём аккаунте GitHub. Перед этим нужно проверить,
что в браузере выполнен вход в свой аккаунт GitHub.

Копия открывается в VS Code через **Source Control → Clone Repository**.
Цикл изменений: **Save → Commit → Push**. Терминал для этого не нужен.

### Публикация на Vercel

Vercel публикует сайт прямо из репозитория GitHub. При импорте проекта
выбирают Framework Preset **Other**, Build Command оставляют пустой. После
каждого Push Vercel создаёт новый Deployment; сайт обновлён, когда Deployment
в статусе **Ready**.

| Адрес | Что это |
|---|---|
| Production URL | постоянный адрес сайта, например `ga4-analytics-lab-ivanov.vercel.app` |
| Preview URL | адрес отдельного Deployment; меняется при каждой публикации |

Production URL записывают в поле Website URL веб-потока GA4. Measurement ID
при этом не меняется.

### Google Tag

Google Tag — фрагмент кода из инструкции веб-потока GA4. Он ставится
в `<head>` каждой HTML-страницы, по одному разу.

```html
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

| Часть | Что делает |
|---|---|
| первый `<script async>` | загружает библиотеку gtag.js, не останавливая загрузку страницы |
| `dataLayer` | массив, в который складываются команды для тега |
| `gtag()` | функция, которая кладёт команду в `dataLayer` |
| `gtag('config', 'G-…')` | связывает страницу с вашим потоком и отправляет `page_view` |

### Проверка

1. Проверка тега в инструкции потока: «На вашем сайте обнаружен тег Google».
2. Отчёт **Realtime**: после открытия сайта появляется событие `page_view`.
3. Переход по ссылке с UTM в новой сессии: источник появляется в Realtime.
   В стандартных отчётах источник появляется после обработки данных, обычно
   в течение суток. Новая вкладка не гарантирует новую сессию GA4.

## Что делали на занятии

1. Создали копию шаблона `ga4-analytics-lab` на своём аккаунте GitHub.
2. Склонировали её в VS Code.
3. Импортировали репозиторий в Vercel и получили Production URL.
4. Обновили Website URL веб-потока GA4.
5. Вставили Google Tag в `<head>` всех трёх страниц, сделали Commit и Push,
   дождались статуса Ready.
6. Проверили тег, увидели `page_view` в Realtime, открыли сайт по своей
   UTM-ссылке.

## Что вошло в проект

- Свой репозиторий сайта на GitHub и опубликованный сайт на Vercel. Дальше
  все темы с 6-й по 9-ю дорабатывают этот же сайт.
- Google Tag на всех страницах, данные приходят в свой ресурс GA4.

## Документация

- [Vercel: настройка сборки и статический сайт](https://vercel.com/docs/builds/configure-a-build)
- [VS Code: клонирование, commit и синхронизация](https://code.visualstudio.com/docs/sourcecontrol/quickstart)
- [GA4: установка тега](https://support.google.com/analytics/answer/9304153?hl=ru)
- [GA4: кампании, источники и сессии](https://support.google.com/analytics/answer/11242841?hl=ru)
- [Enhanced measurement](https://support.google.com/analytics/answer/9216061?hl=ru)
- Разбор Git по кадрам в этом репозитории: [docs/git/README.md](../docs/git/README.md)
