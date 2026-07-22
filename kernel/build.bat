@echo off
echo =======================================
echo     OneFreedomOS Pure Build System
echo =======================================

:: Прописываем пути к ассемблеру NASM и линкеру LD
SET PATH=%~dp0;%~dp0x86_64-w64-mingw32\bin;%PATH%

:: Прямой путь к сердцу компилятора Си (cc1.exe)
SET CC1_PATH=%~dp0x86_64-w64-mingw32\lib\gcc\x86_64-w64-mingw32\16.1.0

echo [1/3] Ассемблируем загрузчик (NASM)...
nasm -f win32 boot.asm -o boot.o
if %errorlevel% neq 0 goto error

echo [2/3] Компилируем ядро Си напрямую через CC1...
"%CC1_PATH%\cc1.exe" kernel.c -m32 -o kernel.s -ffreestanding -O2
if %errorlevel% neq 0 goto error

echo [2.5/3] Переводим код в объектный файл...
as --32 kernel.s -o kernel.o
if %errorlevel% neq 0 goto error

echo [3/3] Склеиваем всё через линкер (LD)...
ld -m i386pe -T linker.ld -o kernel.tmp boot.o kernel.o
if %errorlevel% neq 0 goto error

echo [3.5/3] Очищаем от заголовков Windows в чистый бинарник
x86_64-w64-mingw32\bin\objcopy.exe -I pe-i386 -0 binary kernel.tmp kernel.bin
if %errorlevel% neq 0 goto error

echo ---------------------------------------
echo [УСПЕХ] Твоя операционка kernel.bin собрана!
echo ---------------------------------------
echo [ЗАПУСК] Погнали! Запускаем OneFreedomOS в Bochs

"Bochs-2.6.11\bochs.exe" -q -f bochsrc.txt
pause
exit

:error
echo ---------------------------------------
echo [ОШИБКА] Сборка сорвалась. Проверь пути!
echo ---------------------------------------
pause
