/*
 * 效能比較程式 - 比較兩種版本的執行效率
 * Performance comparison program - Compare execution efficiency of both versions
 */

#include <stdio.h>
#include <time.h>

// 低效率版本函數
double inefficient_version(int N) {
    const int divisor1 = 7;
    const int divisor2 = 13;
    const int divisor3 = 23;
    double sum = 0.0;
    
    for (int i = 1; i <= N; i++) {
        // 每次迭代都重複計算除法
        double factor1 = 100.0 / divisor1;
        double factor2 = 200.0 / divisor2;
        double factor3 = 300.0 / divisor3;
        
        sum += i * factor1 + i * factor2 + i * factor3;
        
        if (i % 1000 == 0) {
            double progress = (double)i / N * 100.0;
        }
    }
    return sum;
}

// 高效率版本函數
double efficient_version(int N) {
    const int divisor1 = 7;
    const int divisor2 = 13;
    const int divisor3 = 23;
    double sum = 0.0;
    
    // 將除法計算移到迴圈外
    double factor1 = 100.0 / divisor1;
    double factor2 = 200.0 / divisor2;
    double factor3 = 300.0 / divisor3;
    double percent_factor = 100.0 / N;
    
    for (int i = 1; i <= N; i++) {
        // 只使用乘法，避免重複除法
        sum += i * factor1 + i * factor2 + i * factor3;
        
        if (i % 1000 == 0) {
            double progress = i * percent_factor;
        }
    }
    return sum;
}

int main() {
    const int N = 1000000;
    clock_t start, end;
    double time_inefficient, time_efficient;
    double result1, result2;
    
    printf("=== 效能比較測試 ===\n");
    printf("=== Performance Comparison Test ===\n");
    printf("迴圈次數 / Loop iterations: %d\n\n", N);
    
    // 測試低效率版本
    printf("1. 測試低效率版本 (除法在迴圈內)...\n");
    printf("1. Testing inefficient version (divisions inside loop)...\n");
    start = clock();
    result1 = inefficient_version(N);
    end = clock();
    time_inefficient = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("   結果: %.2f\n", result1);
    printf("   執行時間: %.4f 秒\n\n", time_inefficient);
    
    // 測試高效率版本
    printf("2. 測試高效率版本 (除法移出迴圈)...\n");
    printf("2. Testing efficient version (divisions moved outside loop)...\n");
    start = clock();
    result2 = efficient_version(N);
    end = clock();
    time_efficient = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("   結果: %.2f\n", result2);
    printf("   執行時間: %.4f 秒\n\n", time_efficient);
    
    // 結果分析
    printf("=== 分析結果 ===\n");
    printf("=== Analysis Results ===\n");
    printf("結果正確性: %s\n", (result1 == result2) ? "✓ 相同" : "✗ 不同");
    printf("Result correctness: %s\n", (result1 == result2) ? "✓ Same" : "✗ Different");
    
    if (time_inefficient > 0) {
        double speedup = time_inefficient / time_efficient;
        printf("效能提升: %.2fx 倍\n", speedup);
        printf("Performance improvement: %.2fx times\n", speedup);
        printf("時間節省: %.1f%%\n", (1.0 - time_efficient/time_inefficient) * 100.0);
        printf("Time saved: %.1f%%\n", (1.0 - time_efficient/time_inefficient) * 100.0);
    }
    
    return 0;
}