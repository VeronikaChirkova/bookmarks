Социальный веб-сайт
Книга Антонио Меле Django-4

    1) Авторизация (Вход и Выход из аккаунта)
    2) Смена пароля
    3) Восстановление пароля
    4) Регистрация пользователей и профили пользователей
    5) Расширение модели пользователя (добавим Profile к User)
    6) Подключение системы уведомлений (messages)
    7) Разработка конкретно-прикладного бэкенда аутентификации (вход по email)
    8) Социальная аутентификация через сторонние приложения (Google)
    9) Создание профиля пользователей, регистрирующихся посредством социальной аутентификации
    10) Создание веб-сайта для управления визуальными закладками
    11) Создание взаимосвязей многие-ко-многим
    12) Отправка контента с других сайтов
    13) Разработка букмарклета с по­мощью JavaScript


Создание и активация виртуального окружения:<br>
```bash
python -m venv env
. ./env/bin/activate
```
Установить Django:<br>
```bash
pip install Django
```
Создать новый проект и в нем создать новое приложение:<br>
```bash
django-admin startproject bookmarks

cd bookmarks/
django-admin startapp account
```
В `INSTALLED_APPS` разместить `'account.apps.AccountConfig'`, на самом верху, чтобы использовать мои шаблоны:<br>
```bash
python manage.py migrate
```
## Авторизация

Вход в систему:

    Form - По умолчанию Django использует форму AuthenticationForm из модуля django. contrib.auth.forms

 1. Внутри приложения account создаем новый файл forms.py -> views.py -> URL-шаблон в account создайте новый файл urls.py -> главный файл urls.py<br>

 2. Создаем шаблон входа в систему по URL-адресу:<br>
 ```text
 templates/
     account/
         login.html
     base.html
 ```
 3. Шаблон стилей CSS: account/static/css/base.css<br>
 4. Создание суперпользователя:<br>
 ```bash
 python manage.py createsuperuser
 ```

Выход:<br>

 1. URL-шаблон c представлением LogoutView.<br>
 2. HTML-шаблон templates/registration/login.html (стандартный путь для LogoutView по которому представления аутентификации будут обращаться к шаблонам аутентификации).<br>
 3. HTML-шаблон templates/registration/logged_out.html - шаблон, который будет отображаться после выхода пользователя.<br>
 4. В views.py создали представление dashboard.<br>
 5. Создать шаблон представления dashboard -> templates/account/dashboard.html<br>
 6. В urls.py добавить шаблон URL-адреса представления.<br>
 7. Переадресация на страницу dashboard:<br>
    В settings.py:<br>
    ```text
    LOGIN_REDIRECT_URL = 'dashboard' - указывает адрес, куда Django будет перенаправлять пользователя при успешной авторизации, если не указан GET-параметр next.

    LOGIN_URL = 'login' - адрес, куда нужно перенаправлять пользователя для входа в систему, например из обработчиков с декоратором login_required.

    LOGOUT_URL = 'logout' - адрес, перейдя по которому, пользователь выйдет из своего аккаунта.
    ```
    URL-шаблон path('', views.dashboard, name='dashboard')<br>
    HTML-шаблон account/dashboard.html<br>
    View dashboard<br>
    @login_required- проверяет аутентификацию. Если юзер авторизован - покажи ему страницу dashboard, иначе перенаправь на страницу login.html<br>

8. Добавить ссылки на страницы входа и выхода в templates/base.html<br>

## Смена пароля

Используем встроенные представления<br>

 1) В urls.py добавить URL-шаблоны:<br>

    `PasswordChangeView` - обрабатывает форму смены пароля.<br>
    `PasswordChangeDoneView `- обработчик, на который будет перенаправлен пользователь после успешной смены пароля. Отображает сообщение о том, что операция выполнена успешно.<br>

 2) HTML-шаблон templates/registration/password_change_form.html - отображает форму для смены пароля.<br>

 3) HTML-шаблон templates/registration/password_change_done.html - содержит простое сообщение, которое говорит об успешной смене пароля.<br>

## Восстановление пароля

 1) В urls.py добавить URL-шаблоны c:<br>

    `PasswordResetView` - обработчик восстановления пароля. Он генерирует временную ссылку с токеном и отправляет ее на электронную почту пользователя.<br>
    `PasswordResetDoneView` - отображает страницу с сообщением о том, что ссылка восстановления пароля была отправлена на электронную почту.<br>
    `PasswordResetConfirmView` - проверяет валидность указанного в URL-адресе токена и передает переменную validlink в шаблон.<br>
    `PasswordResetCompleteView` - отображает сообщение об успешной смене пароля.

 2) HTML-шаблон templates/registration/password_reset_form.html - отображает форму восстановления пароля.<br>Эта форма отправляет сообщение на email с ссылкой для смены пароля.<br>

 3) HTML-шаблон templates/registration/password_reset_email.html - использоваться для отображения отправляемого пользователям электронного письма, чтобы сбросить свой пароль.<br>

 4) HTML-шаблон templates/registration/password_reset_done.html - содержит сообщение о том, что email ушел по адресу.<br>

 5) HTML-шаблон templates/registration/password_reset_confirm.html - подтверждаем валидность/невалидность ссылки на сброс пароля. <br>Если ссылка валидна, то отображается форма для сброса пароля пользователя.<br>

 6) HTML-шаблон templates/registration/password_reset_complete.html - содержит сообщение об успешной смене пароля.<br>

 7) Настроить smtp-сервер в файл добавить settings.py (email в консоль):<br>
    ```text
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
    ```

## Регистрация пользователей и профили пользователей

1) В forms.py создаем форму для модели пользователя:<br>
    Form UserRegistrationForm(forms.ModelForm) созданная по модели User.
    Поля – password и password2, – чтобы пользователи могли устанавливать пароль и повторять его.<br>
    Метод clean_password2()-чтобы сравнивать второй пароль с первым и выдавать ошибки валидации, если пароли не совпадают.<br>

2) В views.py - представление создания учетных записей пользователей.<br>

3) В urls.py URL-шаблон для регистрации.<br>

4) HTML-шаблоны templates/account/register и register_done для регистрации и подтверждения регистрации.<br>

5) Добавим ссылку на регистрацию в шаблон входа registration/login.html.<br>

## Расширение модели пользователя (добавим Profile к User)

Когда пользователь регистрируется на сайте, мы создаем пустой профиль, ассоциированный с ним.<br>
Для ранее зарегистрированных пользователей профиль создастся при переходе по ссылке в профиль в view edit.<br>

 1) В models.py создаем модель Profile со связью OneToOneField c User<br>
 2) Установить библиотеку Pillow-для поля типа ImageField, чтобы сохранять фото.<br>
 ```bash
 pip install Pillow
 ```
 3) В settings.py добавить:<br>
    MEDIA_URL = 'media/' - это базовый URL-адрес,для раздачи медиафайлов, закачанных пользователями на сайт.<br>
    MEDIA_ROOT = BASE_DIR / 'media' - это локальный путь, где они находятся.
 4) Файл urls.py проекта bookmarks добавить - чтобы раздавать медиафайлы с по­мощью сервера разработки во время разработки:<br>
```text
if settings.DEBUG: urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)
```
 5) Сделать миграции.<br>
 6) Добавить модель Profile в admin.py<br>
 7) В account/forms.py cjplfnm ajhvs:<br>
    UserEditForm - позволит пользователям редактировать свое ФИО,email,которые являются атрибутами встроенной в Django модели User;<br>
    ProfileEditForm позволит пользователям редактировать данные профиля, сохраненные в конкретно-прикладной модели Profile.<br>
 8) Сделать view edit для их отображения.<br>
 9)  Добавить в view register код для создания профиля пользователя Profile.objects.create(user=new_user) в модели Profile.<br>
 10)  Добавить шаблон URL-адреса в urls.py/account<br>
 11)  HTML-шаблон templates/account/edit.html<br>
 12)  В шаблон информационной панели templates/account/dashboard.html вставим ссылки на страницы редактирования профиля и смены пароля.<br>

## Подключение системы уведомлений (messages)

1) В HTML-шаблон templates/base.html добавить код для messages (т.к система сообщений настраивается к проекту глобально).<br>

2) Добавить в нужный account/view код:<br>
  ```text
    messages.success(request, 'Profile updated successfully')
    messages.error(request, 'Error updating your profile')
  ```

3) Система сообщений автоматически подключает контекстный процессор django.contrib.messages.context_processors.messages, который добавляет переменную message в контекст.<br>

## Разработка конкретно-прикладного бэкенда аутентификации (вход по email)

Если пользователь в поле username вводит свой email, то бэкенды срабатывают по очереди и EmailAuthBackend запускает в систему пользователя.<br>
Создать свой бэкэнд – это значит создать Python-класс, который реализует 2 метода - authenticate и get_user.<br>
Добавим бэкэнд, который даст возможность пользователям использовать e-mail вместо логина для входа на сайт.<br>

1) В account/uthentication.py cоздаем класс EmailAuthBackend(object) в котором определяем эти 2 метода:<br>
    authenticate - принимает в качестве параметров объект запроса request и идентификационные данные пользователя. Он должен возвращать объект пользователя, если данные корректны; в противном случае – None.
    get_user - принимает ID и должен вернуть соответствующий объект пользователя.<br>
2) В settings.py добавляем:<br>
```bash
AUTHENTICATION_BACKENDS = [ 'django.contrib.auth.backends.ModelBackend', 'account.authentication.EmailAuthBackend', ]
```
3) Предотвращение регистрации пользователей с существующим адресом электронной почты forms.py/forms.py класс UserRegistrationForm и UserEditForm.<br>

## Аутентификация через сторонние приложения

 1) Установить Python Social Auth:<br>
```bash
pip install social-auth-app-django
```
 2) В settings.py добавить INSTALLED_APPS -> 'social_django'<br>

 3) Миграция <br>
```bash
python manage.py migrate
```
 4) В bookmarks/urls.py добавить шаблон URL-адресов path('social-auth/', include('social_django.urls', namespace='social'))<br>

 5) Открыть sudo nano /etc/hosts. Добавить в /etc/hosts -> 127.0.0.1 mysite.com<br>

 6) Добавить в settings.py/ALLOWED_HOSTS = ['mysite.com', 'localhost', '127.0.0.1']<br>

Обеспечение работы сервера разработкипо протоколу HTTPS<br>

1) Установить: <br>
```bash
pip install django-extensions
```
2) Установить библиотеку Werkzeug:<br>
```bash
pip install werkzeug
```
3) Установить pyOpenSSL:<br>
```bash
pip install pyOpenSSL
```
4) В settings.py/INSTALLED_APPS добавить `'django_extensions',`<br>

5) Самоподписанный сертификат django_extensions:<br>
    python manage.py runserver_plus --cert-file cert.crt -> ошибка -> дополнительно -> перейти по 127.0.0.1 (небезопасно)

## Аутентификация с учетной записью Google

 1) В settings.py/AUTHENTICATION_BACKENDS добавить:<br>
```text
'social_core.backends.google.GoogleOAuth2',
```
 2) Cоздать ключ API https://console.cloud.google.com/projectcreate<br>

 3) Project name - Bookmarks (Закладки) -> CREATE<br>

 4) APIs and services -> Credentials -> CREATE CREDENTIALS -> OAuth client ID -> в поле User Type -> External -> CREATE<br>

 5) App name введите Bookmarks -> User support email свою почту.<br>

 6) Authorised domains -> mysite.com<br>

 7) Developer contact information свою почту -> SAVE AND CONTINUE.<br>

 8) На шаге 2 Scopes ничего не меняйте и кликните по SAVE AND CONTINUE.<br>

 9)  На шаге 3 Test users добавьте пользователя Google в раздел Test users -> SAVE AND CONTINUE -> Back to dashboard.<br>

 10) Credentials -> Create credentials -> OAuth client ID -> Application type - Web application -> Name - Bookmarks; Авторизованные источники JavaScript: https://mysite.com:8000/; Authorised redirect URIs: https://mysite.com:8000/social-auth/complete/google-oauth2/ -> CREATE<br>

 11) Добавьте ключи в файл settings.py:<br>
```text
    SOCIAL_AUTH_GOOGLE_OAUTH2_KEY = 'XXX' # ИД клиента Google
    SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET = 'XXX' # Секрет клиента Google
```
 12) В registration/login.html добавить ссылку для кнопки google.<br>

 13) ```bash
        python manage.py runserver_plus --cert-file cert.cr
        ```

## Создание профиля пользователей, регистрирующихся посредством социальной аутентификации

1) В account/authentication.py добавить код.<br>
        Функция create_profile принимает два необходимых аргумента:<br>
        • backend: используемый для аутентификации пользователей бэкенд социальной аутентификации. <br>
        • user: экземпляр класса User нового либо существующего пользователя,прошедшего аутентификацию.<br>

2) В SOCIAL_AUTH_PIPELINE в файле settings.py добавить:<br>
    ```text
    SOCIAL_AUTH_PIPELINE = [
    'social_core.pipeline.social_auth.social_details',
    'social_core.pipeline.social_auth.social_uid',
    'social_core.pipeline.social_auth.auth_allowed',
    'social_core.pipeline.social_auth.social_user',
    'social_core.pipeline.user.get_username',
    'social_core.pipeline.user.create_user',
    'account.authentication.create_profile',
    'social_core.pipeline.social_auth.associate_user',
    'social_core.pipeline.social_auth.load_extra_data',
    'social_core.pipeline.user.user_details',
    ]
    ```
Функция create_profile использует экземпляр класса User, чтобы отыскивать соответствующий объект Profile и создавать новый, если это необходимо.<br>

## Создание веб-сайта для управления визуальными закладками

1) Сщздаем новое приложение:<br>
   ```bash
    django-admin startapp images
   ```
2) Добавьте приложение в INSTALLED_APPS/settings.py - '`images.apps.ImagesConfig',`<br>
3) Создать модель в images/models.py и добавить функцию автоматической генерации поля slug<br>

## Создание взаимосвязей многие-ко-многим

   Cоздание модели для хранения изображений:<br>

1) Добавить в модель Image связь ManyToManyField.<br>
2) Миграции:<br>
   ```bash
    python manage.py makemigrations images
    python manage.py migrate images
   ```
3) В images/admin.py зарегистрировать модель Image.<br>
4) Запуск сервера:
   ```bash
   python manage.py runserver_plus --cert-file cert.crt
   ```

## Отправка контента с других сайтов

1) Создать форму для передачи новых изображений на обработку в images/forms.py<br>
2) Создатьт класс ImageCreateForm: в images/forms.py<br>
3) Установить библиоетеку requests:<br>
   ```bash
    pip install requests
   ```
4) Переопределяем метод save() ImageCreateForm:в images/forms.py, чтобы получать файл изображения по переданному URL-адресу и сохранить его в файловой системе.<br>
5) В images/views.py добавить представление для хранения изображений на сайте.<br>
6) В images/urls.py вставить URL-шаблон.<br>
7) В bookmarks/urls.py встасить:<br>
   ```text
   path('images/', include('images.urls', namespace='images')),
   ```
8) Создать HTML: templates/images/image/create.html<br>
9) python manage.py runserver_plus --cert-file cert.crt

## Разработка букмарклета с по­мощью JavaScript

1) Создать шаблон для запуска букмарклета в images/templates/bookmarklet_launcher.js<br>
2) Для добавления букмарклета в закладки добавить код в шаблон account/dashboard.html<br>
3) Создать static/js/bookmarklet.js и static/css/bookmarklet.css<br>
4) python manage.py runserver_plus --cert-file cert
.crt~