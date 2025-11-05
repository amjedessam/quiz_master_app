@echo off
:loop

REM التحقق من تغييرات ملفات Dart وملفات واجهة مهمة فقط
git diff --name-only -- '*.dart' 'pubspec.yaml' '*.json' > temp.txt
setlocal enabledelayedexpansion
set "changes="
for /f "delims=" %%f in (temp.txt) do (
    set "changes=!changes! %%f"
)

if not "!changes!"=="" (
    REM أضف الملفات المعدلة فقط
    git add .

    REM تجاهل الملفات غير المهمة
    git reset .metadata
    git reset *.gradle
    git reset .idea
    git reset pubspec.lock

    REM commit برسالة تلقائية تحتوي على أسماء الملفات المعدلة
    git commit -m "تحديث تلقائي:!changes!"
    git push
)

del temp.txt
timeout /t 5
goto loop