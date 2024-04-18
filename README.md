Социальный веб-сайт
Книга Антонио Меле Django-4


    1) Аутентификация
    env
    Авторизация (Вход и Выход из аккаунта)
    Переадресация на страницу dashboard
    Смена пароля
    Восстановление пароля
    Регистрация пользователей
    Расширение модели пользователя (добавим Profile к User)
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

Смена пароля

Используем вьюхи из коробки.

    URL-шаблоны c:

    PasswordChangeView - обрабатывает форму смены пароля.
    PasswordChangeDoneView - обработчик, на который будет перенаправлен пользователь после успешной смены пароля. Отображает сообщение о том, что операция выполнена успешно.

    HTML-шаблон templates/registration/password_change_form.html - отображает форму для смены пароля.
    HTML-шаблон templates/registration/password_change_done.html - содержит простое сообщение, которое говорит об успешной смене пароля.

Восстановление пароля

Используем вьюхи из коробки, подключив smtp-сервер.

    URL-шаблоны c:

    PasswordResetView - обработчик восстановления пароля. Он генерирует временную ссылку с токеном и отправляет ее на электронную почту пользователя.
    PasswordResetDoneView - отображает страницу с сообщением о том, что ссылка восстановления пароля была отправлена на электронную почту.
    PasswordResetConfirmView - позволяет пользователю указать новый пароль.
    PasswordResetCompleteView - отображает сообщение об успешной смене пароля.

    HTML-шаблон templates/registration/password_reset_form.html - отображает форму восстановления пароля. Эта форма отправляет сообщение на email с ссылкой для смены пароля.
    HTML-шаблон templates/registration/password_reset_email.html - в этом шаблоне формируется сообщение с той самой ссылкой, отправляемое пользователю на email после password_reset_form.html
    HTML-шаблон templates/registration/password_reset_done.html - содержит сообщение о том, что email ушел по адресу.
    HTML-шаблон templates/registration/password_reset_confirm.html - если ссылка из password_reset_email.html еще валидна, то отобразит форму восстановления пароля, иначе скажет, что ссылка уже не валидна.
    HTML-шаблон templates/registration/password_reset_complete.html - содержит сообщение об успешной смене пароля.
    Настроить smtp-сервер, хотя бы консольный (в нашем случае достаточно заполнить переменную EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'), вьюхи из коробки автоматически отправят email в консоль.

Регистрация пользователей

    Form UserRegistrationForm(forms.ModelForm) созданная по модели User.
    HTML-шаблоны register и register_done для регистрации и подтверждения регистрации.
    URL-шаблон для регистрации.
    View в которой обрабатывается логика регистрации(GET) и подтверждения регистрации(POST)

Расширение модели пользователя (добавим Profile к User)

Когда пользователь регистрируется на сайте, мы создаем пустой профиль, ассоциированный с ним.
Для ранее зарегистрированных пользователей профиль создастся при переходе по ссылке в профиль в view edit

    Cоздаем модель Profile со связью 1к1 c User
    Сделать миграции
    Добавить модель в админку
    pip install pillow - для поля типа ImageField, чтобы сохранять фотки.
    Для встроенной модели User нам не нужно добавлять в settings.AUTH_USER_MODEL, эта модель по умолчанию в ней прописана, даже если AUTH_USER_MODEL нет в settings.py , однако если модель кастомная, то необходимо это сделать AUTH_USER_MODEL=myapp.MyUser
    settings.py -> MEDIA_URL = '/media/',MEDIA_ROOT = os.path.join(BASE_DIR, 'media/')
    В URL-шаблоне bookmarks/urls.py добавить if settings.DEBUG: urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT) тк мы сохраняем фото
    Создать формы UserEditForm и ProfileEditForm
    Сделать view edit для их отображения.
    Добавить в view register код для создания профиля пользователя Profile.objects.create(user=new_user) в моделиProfile
    HTML-шаблон edit.html

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
