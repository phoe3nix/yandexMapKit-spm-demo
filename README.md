# yandexMapKit-spm-demo

Всем привет! Так как Swift Package Manager продолжает быстро развиваться, некоторые компании не успевают поддержать его, как способ дистрибьюции своих продуктов. Данный гайд показывает пример подключения бибилотеки YandexMapKit через SPM, но подход к каким-то другим зависимостям должен быть похож, за исключением деталей.

# С чего начать?

На данный момент SPM поддерживает механизм подключения зависимостей в бинароном виде. Но есть небольшие ограничения. 

1. Зависимость должна быть представлена в виде xcframework (universal framework).
2. Зависимость должна находиться удалённо на каком-то облаке, хранилище артефактов, хостинге и т.д.

Итак, предположим, что раньше мы подключали YandexMapKit через CocoaPods. Соответсвенно, у нас в проекте есть папка `Pods`. Внутри находятся нужные нам папки. Это `YandexMapKit` и `YandexRuntime`. В них находятся соответствующие бинарные зависимости, только в формате `framework`. Теперь наступает самая интересная часть. Необходимо преобразовать формат `framework` в `xcframework`. 

Начнём с YandexMapKit, а для YandexRuntime действия будут аналогичные. Для начала найдём сам бинарник, он находится по пути `YandexMapKit.framework/Versions/A/YandexMapKit`. Проверим, что в нём присутствуют все архитектуры. Для этого воспользуемся командой `lipo -archs YandexMapKit` (необходимо выполнять в директрии `A`). Должны увидеть список из 4-х архитектур: armv7 i386 x86_64 arm64. Далее, нужно разбить этот fat binaries на отдельные архитектуры. Например, извлёчем архитектуру для симулятора x86_64 командой `lipo -thin x86_64 YandexMapKit -output YandexMapKit_x86_64`. Это действие повторяем для всех архитектур, которые остались. Затем надо собрать fat binaries отдельно для симулятора и девайса. Для этого нам надо соединить `x86_64` и `i386`, а также `armv7` и `arm64` в fat binaries. Сделать это можно командой `lipo -create YandexMapKit_x86_64 YandexMapKit_i386 -output YandexMapKit_sim`. Тем самым мы получили бинарник `YandexMapKit_sim`, который содержит архитектуры только для симуляторов. Повторяем прошлое действие, но теперь для архитектур девайса `lipo -create YandexMapKit_armv7 YandexMapKit_arm64 -output YandexMapKit_device`. В итоге получаем бинарник `YandexMapKit_device`. Теперь предлагаю на время вернуться к директории `Pods`, где находились папки `YandexMapKit` и `YandexRuntime`. Предлагаю создать дубликат папки `YandexMapKit`. Одну можно назвать `YandexMapKit_device`, а другую `YandexMapKit_sim`. Начнём с `YandexMapKit_device`, переходим в папку, по пути `YandexMapKit.framework/Versions/A`. Удаляем бинарники `YandexMapKit` и `YandexMapKit_sim`, а `YandexMapKit_device` переименовываем в `YandexMapKit`. Тоже самое, делаем в папке `YandexMapKit_sim`, только оставляем бинарник `YandexMapKit_sim`, а затем переименовываем его просто в `YandexMapKit`. Остался последний шаг, это сделать `xcframework`. Возвращаемся в папку `Pods` и выполняем команду `xcodebuild -create-xcframework -framework YandexMapKit_sim/YandexMapKit.framework -framework YandexMapKit_device/YandexMapKit.framework -output YandexMapKit.xcframework`. После её выполнения в этой директории должен появится `YandexMapKit.xcframework`. 

Все те же шаги, только заменяя YandexMapKit на YandexRuntime, необходимо выполнить для библиотеки `YandexRuntime.framework`.

# SPM Packages

Теперь смотрим на локальные package. Их два: Maps и YandexMapsWrapper. Второй это всего лишь umbrella package, который содержит в себе лишь линковку двух xcframework. Package Maps линкует уже к себе package YandexMapsWrapper, и здесь мы уже можем писать всякие хэлперы для карт или нужные нам классы, связанные с картой в нашем приложении.

По поводу манифест файла для YandexMapsWrapper. Там присутсвует `binaryTarget`. В поле url помещается ссылка до вашего файла, который должен лежать на каком-то хостинге (локально не проверял). Файл должен быть в формате xcframework или zip. Поле checksum получается выполнением команды `swift package compute-checksum YandexMapKit.xcframework.zip`. Необходимо обратить внимание на тот факт, что если на хостинг будет загружаться архив, то и контроль-сумму надо будет высчитывать от архива. И выполнение этой команды возможно только в том месте, где есть `Package.swift` файл.

# Запуск приложения

Билд должен быть успешным после всех этих действий. Но если начнём запускать приложение, то увидим странную ошибку. Дело в том, что xcframework линкуется внутрь статической бибилотеки, но он всё равно присутствует в итоговом приложении в папке frameworks. Ему там не место, поэтому удаляем его.

1. Заходим в `Edit Scheme` схемы основного приложения.
2. Раскрываем поле `Build` и нажимаем `Post Actions`.
3. Добавляем скрипт и выбираем build settings из приложения.
4. Затем добавляем сам код скрипта.
```bash
rm -rf "${TARGET_BUILD_DIR}/${TARGET_NAME}.app/Frameworks/YandexMapKit.framework"
rm -rf "${TARGET_BUILD_DIR}/${TARGET_NAME}.app/Frameworks/YandexRuntime.framework"
```
 
После этого приложение должно будет запуститься успешно.

# Возможные проблемы

1. Линковщик ругается на отсутствующие символы из бибилотеки c++

Для решения это проблемы необходоимо вернуться в манифест файла для пакета YandexMapsWrapper и к таргету YandexMapsLibraries добавить настройку `linkerSettings: [.linkedLibrary("c++"),]`.