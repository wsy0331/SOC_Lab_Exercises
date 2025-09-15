# Makefile for Division Optimization Demo
# 除法優化示範的編譯檔案

CC = gcc
CFLAGS = -Wall -O2 -std=c99
TARGETS = inefficient_division efficient_division performance_comparison

.PHONY: all clean test run

all: $(TARGETS)

# 編譯低效率版本
inefficient_division: inefficient_division.c
	$(CC) $(CFLAGS) -o $@ $<

# 編譯高效率版本  
efficient_division: efficient_division.c
	$(CC) $(CFLAGS) -o $@ $<

# 編譯效能比較程式
performance_comparison: performance_comparison.c
	$(CC) $(CFLAGS) -o $@ $<

# 執行測試
test: all
	@echo "=== 執行效能比較測試 ==="
	@echo "=== Running Performance Comparison Test ==="
	@./performance_comparison

# 分別執行兩個版本
run: all
	@echo "=== 執行低效率版本 ==="
	@./inefficient_division
	@echo ""
	@echo "=== 執行高效率版本 ==="
	@./efficient_division

# 清理編譯檔案
clean:
	rm -f $(TARGETS)

# 幫助資訊
help:
	@echo "可用的目標 / Available targets:"
	@echo "  all    - 編譯所有程式 / Compile all programs"
	@echo "  test   - 執行效能比較測試 / Run performance comparison test"
	@echo "  run    - 分別執行兩個版本 / Run both versions separately"
	@echo "  clean  - 清理編譯檔案 / Clean compiled files"
	@echo "  help   - 顯示此幫助 / Show this help"