/*
 * 低效率版本 - 除法操作集中在 for 迴圈內
 * Inefficient version - Division operations concentrated in for loop
 * 
 * 這個程式展示了在迴圈內重複進行除法計算的問題
 * This program demonstrates the problem of repeated division calculations inside a loop
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
    
    printf("執行低效率版本 (除法在迴圈內)...\n");
    printf("Running inefficient version (divisions inside loop)...\n");
    
    // 問題：所有除法操作都在迴圈內，每次迭代都要重複計算
    // Problem: All division operations are inside the loop, recalculated every iteration
    for (int i = 1; i <= N; i++) {
        // 重複的除法計算 - 這些值在每次迭代時都相同但被重複計算
        // Repeated division calculations - these values are same every iteration but recalculated
        double factor1 = 100.0 / divisor1;     // 重複計算 100/7
        double factor2 = 200.0 / divisor2;     // 重複計算 200/13  
        double factor3 = 300.0 / divisor3;     // 重複計算 300/23
        
        // 使用這些因子進行計算
        // Use these factors for calculation
        sum += i * factor1 + i * factor2 + i * factor3;
        
        // 更多在迴圈內的除法操作
        // More division operations inside the loop
        if (i % 1000 == 0) {
            double progress = (double)i / N * 100.0;  // 重複的百分比計算
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