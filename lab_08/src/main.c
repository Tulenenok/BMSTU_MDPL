// Примечания
// df -- флаг направления, используется в командах поточной обработки данных
// 1 -- строки обрабатываются в сторону уменьшения адресов, 0 -- иначе
// zf -- флаг нуля, принимает единичное значение, если в результате арифметической операции получился 0

// про r: сам по себе он лишь говорит, что значение будет лежать в каком-то регистре общего назначения
// если бы мы хотели использовать конкретные регистры, то понадобились бы буквы
// а -- eax, al, ax
// b -- ebx, bl, bx   
// c -- ecx, cl, cx   
// d -- edx, dl, dx   
// S -- esi, si
// D -- dsi, di


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define N 100

int asm_len(const char *str)
{
    int len = 0;
    const char *copy = str;

    __asm__(
    	// бежим, пока не найдем нулевой символ -- признак конца строки
        "mov $0, %%al\n\t"                    // поместить 0 в al
        "mov %1, %%rdi\n\t"                   // кладем в rdi адрес нашей строки
        "mov $0xffffffff, %%ecx\n\t"          // в ecx очень большое число, чтобы цикл на следующей строчке выполнялся, пока zf не станет = 1
        "repne scasb\n\t"                     // scasb сравнивает al с байтом по адресу rdi, после чего rdi увеличивается или уменьшается на 1 в зависимости от df
        
        // Получаем длинну
        "not %%ecx\n\t"                       // инвертируем 
        "dec %%ecx\n\t"                       // -1, получили, сколько раз выполнился цикл
        "mov %%ecx, %0"                       // передаем то, что получили в 0 переменную
        
        : "=r"(len)                           // выходные операнды (r -- работа с регистрами общего назначения)
        : "r"(copy)                           // входные операнды
        : "%ecx", "%rdi", "%al"               // регистры, которые будут разрушены в результате выполнения кода вставки
    );
    return len;
}

void strcopy(char *dest, char *src, int len);

int one_strlen_test(char *s, int i)
{
    int a_len = asm_len(s);
    int s_len = strlen(s);
    
    if (a_len == s_len)
    	printf("TEST %d ---> SUCCESS  (string: %s, asm_len: %d, strlen: %d)\n", i, s, a_len, s_len);
    	return EXIT_SUCCESS;
    
    printf("TEST %d ---> FAILURE  (string: %s, asm_len: %d, strlen: %d)                  !!!\n", i, s, a_len, s_len);
    return EXIT_FAILURE;
}

int tests_for_strlen()
{
    int rc = 0;
    rc += one_strlen_test("123", 1);
    rc += one_strlen_test("a", 2);
    rc += one_strlen_test("hgfhg", 3);
    rc += one_strlen_test("", 4);
    rc += one_strlen_test("----", 5);
    
    return rc;
}

int one_strncopy_test(char *dst, char *src, int len, char *res, int i)
{
    char copy_dst[N + 10];
    strcpy(copy_dst, dst);
    
    strcopy(dst, src, len);
    if (strcmp(dst, res) == 0)
    	printf("TEST %d ---> SUCCESS (dst: %s, src: %s, len: %d, res_func: %s, res_perf: %s)\n", i, copy_dst, src, len, dst, res);
    	return EXIT_SUCCESS;
    	
    printf("TEST %d ---> FAILURE (dst: %s, src: %s, len: %d, res_func: %s, res_perf: %s)\n", i, copy_dst, src, len, dst, res);
    return EXIT_FAILURE;
}

int tests_for_strcopy()
{
    int rc = 0;
    
    char src1[] = "abcdef";
    char dst1[N] = "0123";
    char res1[N] = "abcde";
    rc += one_strncopy_test(dst1, src1, 5, res1, 1);
    
    char src2[] = "abcdef";
    char dst2[N] = "0123";
    char res2[N] = "ab23";
    rc += one_strncopy_test(dst2, src2, 2, res2, 2);
    
    char src3[] = "abcdef";
    char dst3[N] = "0123";
    char res3[N] = "abcdef";
    rc += one_strncopy_test(dst3, src3, 10, res3, 3);
    
    char src4[N] = "abcdef";
    char res4[N] = "abcd";
    rc += one_strncopy_test(src4 + 2, src4, 4, res4, 4);
    
    char src5[N] = "abcdef";
    char res5[N] = "cdefef";
    rc += one_strncopy_test(src5, src5 + 2, 4, res5, 5);
    
    return rc;
}

int main(void)
{
    int rc = 0;
    
    printf("Tests for strlen:\n");
    rc += tests_for_strlen();
    	
    printf("\nTests for strcopy:\n");
    rc += tests_for_strcopy();
    
    if (rc == 0)
    	printf("\nAll tests success\n");
}
