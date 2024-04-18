Социальный веб-сайт
Книга Антонио Меле Django-4

    1) Авторизация (Вход и Выход из аккаунта)
    2) Смена пароля
    3) Восстановление пароля
    4) Регистрация пользователей и профили пользователей
    5) Расширение модели пользователя (добавим Profile к User)
    Подключение системы уведомлений (messages)
    Реализация бэкэнда аутентификации (вход по email)
    Аутентификация через сторонние приложения (соц.сети)
    Сохранение изображения с других сайтов в закладки (криво, надо фиксить код js)
    Самоподписанный сертификат django_extensions (python manage.py runserver_plus --cert-file cert.crt)

Создание и активация виртуального окружения:
```bash
python -m venv env
. ./env/bin/activate
```
Установить Django:
```bash
pip install Django
```
Создать новый проект и в нем создать новое приложение:
```bash
django-admin startproject bookmarks

cd bookmarks/
django-admin startapp account
```
В `INSTALLED_APPS` разместить `'account.apps.AccountConfig'`, на самом верху, чтобы использовать мои шаблоны:
```bash
python manage.py migrate
```
## Авторизация

Вход в систему:

    Form - По умолчанию Django использует форму AuthenticationForm из модуля django. contrib.auth.forms

    1. Внутри приложения account создаем новый файл forms.py -> views.py -> URL-шаблон в account создайте новый файл urls.py -> главный файл urls.py

    2. Создаем шаблон входа в систему по URL-адресу:
    ```text
    templates/
        account/
            login.html
        base.html
    ```
    3. Шаблон стилей CSS: account/static/css/base.css
    4. Создание суперпользователя:
    ```bash
    python manage.py createsuperuser
    ```

Выход:

    1. URL-шаблон c представлением LogoutView.
    2. HTML-шаблон templates/registration/login.html (стандартный путь для LogoutView по которому представления аутентификации будут обращаться к шаблонам аутентификации)
    3. HTML-шаблон templates/registration/logged_out.html - шаблон, который будет отображаться после выхода пользователя
    4. В views.py создали представление dashboard
    5. Создать шаблон представления dashboard -> templates/account/dashboard.html
    6. В urls.py добавить шаблон URL-адреса представления.
    7. Переадресация на страницу dashboard:

    В settings.py:
    LOGIN_REDIRECT_URL = 'dashboard' - указывает адрес, куда Django будет перенаправлять пользователя при успешной авторизации, если не указан GET-параметр next
    LOGIN_URL = 'login' - адрес, куда нужно перенаправлять пользователя для входа в систему, например из обработчиков с декоратором login_required
    LOGOUT_URL = 'logout' - адрес, перейдя по которому, пользователь выйдет из своего аккаунта.

    URL-шаблон path('', views.dashboard, name='dashboard')
    HTML-шаблон account/dashboard.html
    View dashboard
    @login_required- проверяет аутентификацию. Если юзер авторизован - покажи ему страницу dashboard, иначе перенаправь на страницу login.html

    8. Добавить ссылки на страницы входа и выхода в templates/base.html

## Смена пароля

Используем встроенные представления

    1) В urls.py добавить URL-шаблоны

    PasswordChangeView - обрабатывает форму смены пароля.
    PasswordChangeDoneView - обработчик, на который будет перенаправлен пользователь после успешной смены пароля. Отображает сообщение о том, что операция выполнена успешно.

    2) HTML-шаблон templates/registration/password_change_form.html - отображает форму для смены пароля.
    3) HTML-шаблон templates/registration/password_change_done.html - содержит простое сообщение, которое говорит об успешной смене пароля.

## Восстановление пароля

Используем вьюхи из коробки, подключив smtp-сервер.

    1) В urls.py добавить URL-шаблоны c:

    PasswordResetView - обработчик восстановления пароля. Он генерирует временную ссылку с токеном и отправляет ее на электронную почту пользователя.
    PasswordResetDoneView - отображает страницу с сообщением о том, что ссылка восстановления пароля была отправлена на электронную почту.
    PasswordResetConfirmView - проверяет валидность указанного в URL-адресе токена и передает переменную validlink в шаблон.
    PasswordResetCompleteView - отображает сообщение об успешной смене пароля.

    2) HTML-шаблон templates/registration/password_reset_form.html - отображает форму восстановления пароля. Эта форма отправляет сообщение на email с ссылкой для смены пароля.
    3) HTML-шаблон templates/registration/password_reset_email.html - использоваться для отображения отправляемого пользователям электронного письма, чтобы сбросить свой пароль.
    4) HTML-шаблон templates/registration/password_reset_done.html - содержит сообщение о том, что email ушел по адресу.
    5) HTML-шаблон templates/registration/password_reset_confirm.html - подтверждаем валидность/невалидность ссылки на сброс пароля. Если ссылка валидна, то отображается форма для сброса пароля пользователя.
    6) HTML-шаблон templates/registration/password_reset_complete.html - содержит сообщение об успешной смене пароля.
    7) Настроить smtp-сервер в файл добавить settings.py (email в консоль):
    ```text
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
    ```

## Регистрация пользователей и профили пользователей

    1) В forms.py создаем форму для модели пользователя:
    Form UserRegistrationForm(forms.ModelForm) созданная по модели User.
    Поля – password и password2, – чтобы пользователи могли устанавливать пароль и повторять его.
    Метод clean_password2()-чтобы сравнивать второй пароль с первым и выдавать ошибки валидации, если пароли не совпадают.
    2) В views.py - представление создания учетных записей пользователей.
    3)В urls.py URL-шаблон для регистрации.
    4) HTML-шаблоны templates/account/register и register_done для регистрации и подтверждения регистрации.
    5) Давайте добавим ссылку на регистрацию в шаблон входа registration/login.html.


## Расширение модели пользователя (добавим Profile к User)

Когда пользователь регистрируется на сайте, мы создаем пустой профиль, ассоциированный с ним.
Для ранее зарегистрированных пользователей профиль создастся при переходе по ссылке в профиль в view edit

    1) В models.py создаем модель Profile со связью OneToOneField c User
    2) Установить библиотеку Pillow-для поля типа ImageField, чтобы сохранять фото.
    ```bash
    pip install Pillow
    ```
    4) В settings.py добавить:
    MEDIA_URL = 'media/' - это базовый URL-адрес,для раздачи медиафайлов, закачанных пользователями на сайт.
    MEDIA_ROOT = BASE_DIR / 'media' - это локальный путь, где они находятся.
    5) Файл urls.py проекта bookmarks добавить if settings.DEBUG: urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT) - чтобы раздавать медиафайлы с по­мощью сервера разработки во время разработки
    6) Сделать миграции.
    7) Добавить модель Profile в admin.py
    8) В account/forms.py cjplfnm ajhvs:
    UserEditForm - позволит пользователям редактировать свое ФИО,email,которые являются атрибутами встроенной в Django модели User;
    ProfileEditForm позволит пользователям редактировать данные профиля, сохраненные в конкретно-прикладной модели Profile.
    9) Сделать view edit для их отображения.
    10) Добавить в view register код для создания профиля пользователя Profile.objects.create(user=new_user) в модели Profile
    11) Добавить шаблон URL-адреса в urls.py/account
    12) HTML-шаблон templates/account/edit.html
    13) В шаблон информационной панели templates/account/dashboard.html вставим ссылки на страницы редактирования профиля и смены пароля.

###Подключение системы уведомлений (messages)

    В HTML-шаблон base.html добавить код для messages (т.к система сообщений настраивается сразу для всего проекта)
    Добавить в нужный view код типа messages.success(request, 'Profile updated successfully')
    Система сообщений автоматически подключает контекстный процессор django.contrib.messages.context_processors.messages, который добавляет переменную message в контекст

Реализация бэкэнда аутентификации (вход по email)

Принцип простой: если пользователь в поле username вводит свой email, то бэкенды срабатывают по очереди и EmailAuthBackend запускает в систему пользователя.
Создать свой бэкэнд – это значит создать Python-класс, который реализует 2 метода - authenticate и get_user
Добавим бэкэнд, который даст возможность пользователям использовать e-mail вместо логина для входа на сайт

Создаем класс EmailAuthBackend(object) в котором определяем эти 2 метода:

    authenticate - принимает в качестве параметров объект запроса request и идентификационные данные пользователя. Он должен возвращать объект пользователя, если данные корректны; в противном случае – None.
    get_user - принимает ID и должен вернуть соответствующий объект пользователя.

Не забываем добавить AUTHENTICATION_BACKENDS = [ 'django.contrib.auth.backends.ModelBackend', 'account.authentication.EmailAuthBackend', ]
Аутентификация через сторонние приложения

Для Facebook нужен https в графе Действительные URI перенаправления для OAuth (https://developers.facebook.com/apps/233990812091626/fb-login/settings/) Для Google не подтянулся редирект на mysite.com, пришлось добавить 127.0.0.1 в строку редиректа в Google.

Как подключить аутентификацию через соц.сеть?

    pip install social-auth-app-django
    INSTALLED_APPS -> 'social_django'
    python manage.py migrate
    path('social-auth/', include('social_django.urls', namespace='social'))
    Добавить в /etc/hosts -> 127.0.0.1 mysite.com
    ALLOWED_HOSTS = ['mysite.com', 'localhost', '127.0.0.1']
    В AUTHENTICATION_BACKENDS добавить 'social_core.backends.facebook.FacebookOAuth2'
    В личном кабинете разработчика создать приложение c OAuth для Web. Получить ID и Secret
    В settings.py SOCIAL_AUTH_FACEBOOK_KEY = 'XXX' # Facebook App ID, SOCIAL_AUTH_FACEBOOK_SECRET = 'XXX' # Facebook App Secret
    Добавить в HTML-шаблон base.html код для кнопки соц.сети.
