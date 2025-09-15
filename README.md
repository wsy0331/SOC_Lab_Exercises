# SOC_Lab_Exercises - 除法優化示範 / Division Optimization Demo

## 問題描述 / Problem Description

目前的程式中，所有的除法操作都集中在 for 迴圈內，這可能導致迴圈的執行時間過長或過多。需要將除法相關的計算邏輯獨立出來，並重新設計程式架構以提升效率。

The current program has all division operations concentrated in the for loop, which may cause the loop execution time to be too long or excessive. Division-related calculation logic needs to be separated and the program architecture redesigned to improve efficiency.

## 解決方案 / Solution

### 問題分析 / Problem Analysis

在原始版本中，除法操作在每次迴圈迭代時都會重複執行，即使這些除法的操作數在整個迴圈期間都保持不變。這造成了不必要的計算開銷。

In the original version, division operations are repeatedly executed in each loop iteration, even though the operands of these divisions remain unchanged throughout the entire loop. This causes unnecessary computational overhead.

### 優化策略 / Optimization Strategy

1. **識別重複計算 / Identify Repeated Calculations**: 找出在迴圈中重複計算但結果不變的除法操作
2. **預先計算 / Pre-calculation**: 將這些除法操作移到迴圈外，只計算一次
3. **使用預計算結果 / Use Pre-calculated Results**: 在迴圈內使用預先計算的結果

## 檔案說明 / File Description

### 核心程式 / Core Programs

- `inefficient_division.c` - 低效率版本，展示除法在迴圈內的問題
- `efficient_division.c` - 高效率版本，展示除法移出迴圈的解決方案
- `performance_comparison.c` - 效能比較程式，同時測試兩種版本並比較效能

### 建置檔案 / Build Files

- `Makefile` - 編譯和測試自動化腳本

## 編譯和執行 / Build and Run

### 編譯所有程式 / Compile All Programs
```bash
make all
```

### 執行效能比較 / Run Performance Comparison
```bash
make test
```

### 分別執行兩個版本 / Run Both Versions Separately
```bash
make run
```

### 清理編譯檔案 / Clean Build Files
```bash
make clean
```

## 關鍵優化點 / Key Optimization Points

### 1. 常數除法優化 / Constant Division Optimization

**低效率版本 (在迴圈內) / Inefficient Version (Inside Loop):**
```c
for (int i = 1; i <= N; i++) {
    double factor1 = 100.0 / divisor1;  // 每次迭代都計算
    double factor2 = 200.0 / divisor2;  // 每次迭代都計算
    double factor3 = 300.0 / divisor3;  // 每次迭代都計算
    
    sum += i * factor1 + i * factor2 + i * factor3;
}
```

**高效率版本 (移出迴圈) / Efficient Version (Outside Loop):**
```c
// 預先計算，只計算一次
double factor1 = 100.0 / divisor1;
double factor2 = 200.0 / divisor2;
double factor3 = 300.0 / divisor3;

for (int i = 1; i <= N; i++) {
    sum += i * factor1 + i * factor2 + i * factor3;  // 只有乘法
}
```

### 2. 百分比計算優化 / Percentage Calculation Optimization

**低效率版本 / Inefficient Version:**
```c
double progress = (double)i / N * 100.0;  // 每次都除以 N
```

**高效率版本 / Efficient Version:**
```c
double percent_factor = 100.0 / N;  // 預先計算
double progress = i * percent_factor;  // 只用乘法
```

## 效能分析 / Performance Analysis

### 時間複雜度分析 / Time Complexity Analysis

- **低效率版本 / Inefficient Version**: O(n) 迴圈 × 3次除法 = O(3n) 除法操作
- **高效率版本 / Efficient Version**: 3次除法 + O(n) 迴圈 × 乘法 = O(3 + n) 操作

### 實際效能提升 / Actual Performance Improvement

執行 `make test` 可以看到具體的效能提升數據，包括：
- 執行時間比較
- 效能提升倍數
- 時間節省百分比

Running `make test` shows specific performance improvement data, including:
- Execution time comparison
- Performance improvement multiplier
- Time saved percentage

## 最佳實踐 / Best Practices

1. **識別不變量 / Identify Invariants**: 尋找在迴圈中不變的計算
2. **預計算 / Pre-calculation**: 將常數計算移到迴圈外
3. **使用乘法替代除法 / Use Multiplication Instead of Division**: 乘法通常比除法快
4. **快取結果 / Cache Results**: 避免重複計算相同的值

## 結論 / Conclusion

通過將除法操作移出迴圈，我們成功地：
- 保持了程式邏輯的正確性
- 顯著提升了執行效率
- 減少了不必要的重複計算
- 遵循了程式優化的最佳實踐

By moving division operations outside the loop, we successfully:
- Maintained program logic correctness
- Significantly improved execution efficiency
- Reduced unnecessary repeated calculations
- Followed programming optimization best practices