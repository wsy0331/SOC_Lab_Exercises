/*
 * 高效率版本 - 除法操作移出 for 迴圈
 * Efficient version - Division operations moved outside for loop
 * 
 * 這個程式展示了將除法計算移出迴圈以提升效能的解決方案
 * This program demonstrates the solution of moving division calculations outside the loop for better performance
 */

#include <stdio.h>
#include <time.h>

int main() {
    const int N = 1000000;  // 大量迴圈次數用於展示效能差異
    const int divisor1 = 7;
    const int divisor2 = 13;
    const int divisor3 = 23;
    
    double sum = 0.0;
    clock_t start = clock();
    
    printf("執行高效率版本 (除法移出迴圈)...\n");
    printf("Running efficient version (divisions moved outside loop)...\n");
    
    // 解決方案：將重複的除法計算移到迴圈外，只計算一次
    // Solution: Move repeated division calculations outside the loop, calculate only once
    double factor1 = 100.0 / divisor1;     // 只計算一次 100/7
    double factor2 = 200.0 / divisor2;     // 只計算一次 200/13  
    double factor3 = 300.0 / divisor3;     // 只計算一次 300/23
    
    // 預先計算百分比計算所需的除法
    // Pre-calculate division needed for percentage calculation
    double percent_factor = 100.0 / N;
    
    // 現在迴圈內只有乘法和加法，沒有除法
    // Now the loop only contains multiplication and addition, no division
    for (int i = 1; i <= N; i++) {
        // 直接使用預先計算的因子，避免重複除法
        // Directly use pre-calculated factors, avoiding repeated division
        sum += i * factor1 + i * factor2 + i * factor3;
        
        // 使用預先計算的因子進行百分比計算
        // Use pre-calculated factor for percentage calculation
        if (i % 1000 == 0) {
            double progress = i * percent_factor;  // 乘法比除法快
            // printf("進度: %.1f%%\n", progress);
        }
    }
    
    clock_t end = clock();
    double time_spent = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("結果: %.2f\n", sum);
    printf("執行時間: %.4f 秒\n", time_spent);
    printf("Result: %.2f\n", sum);
    printf("Execution time: %.4f seconds\n", time_spent);
    
    return 0;
}