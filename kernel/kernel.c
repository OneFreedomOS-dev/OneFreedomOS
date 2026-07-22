// kernel.c - Ядро нашей OneFreedomOS

// Указатель на текстовую видеопамять (экран)
unsigned char* screen = (unsigned char*)0xB8000;

// Функция сравнения строк (чтобы понять команду Python)
int mystrcmp(char* s1, char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(unsigned char*)s1 - *(unsigned char*)s2;
}

// Наш мини-интерпретатор Пайтона!
void run_python(char* command, char* text) {
    if (mystrcmp(command, "print") == 0) {
        int i = 0;
        int screen_pos = 0; // Пишем с верхнего левого угла
        
        while (text[i] != '\0') {
            screen[screen_pos] = text[i];     // Сама буква
            screen[screen_pos + 1] = 0x0A;    // Ярко-зеленый цвет хакера
            screen_pos += 2;                  // Шаг на следующую клетку
            i++;
        }
    }
}

// Главная точка входа, куда прыгает Ассемблер
void kernel_main() {
    // Имитируем чтение строчки print("Hello, 4PDA!") из gui.py
    char* python_command = "print";
    char* python_text = "Hello,OneFreedomOS is running...";
    
    // Запускаем интерпретатор
    run_python(python_command, python_text);

    // Драйвер клавиатуры в засаде
    while (1) {
        unsigned char scancode;
        // Ассемблерная вставка: читаем порт 0x60 в переменную scancode
        __asm__ volatile("inb $0x60, %0" : "=a"(scancode));

        // Если нажали ENTER (скан-код 0x1C)
        if (scancode == 0x1C) {
            screen[0] = 'O'; screen[1] = 0x0A;
            screen[2] = 'K'; screen[3] = 0x0A;
        }
    }
}
