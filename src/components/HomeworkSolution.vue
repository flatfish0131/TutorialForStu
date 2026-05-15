<script setup>
import { computed, ref } from 'vue'

const code = `#include <stdio.h>

int main() {
    int n, m;
    // 讀取地圖的列數 (N) 與行數 (M)
    if (scanf("%d %d", &n, &m) != 2) return 0;

    int map[n][m];
    // 使用雙層迴圈讀取 N x M 個地圖點數
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            scanf("%d", &map[i][j]);
        }
    }

    int k;
    // 讀取要尋找的「關鍵點數」
    scanf("%d", &k);

    int target_r = -1, target_c = -1;
    // 搜尋階段：尋找關鍵點數在矩陣中的座標 (i, j)
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (map[i][j] == k) {
                target_r = i; // 記錄列索引
                target_c = j; // 記錄行索引
                break;
            }
        }
        if (target_r != -1) break; // 若找到則跳出外層迴圈
    }

    // 判定階段：檢查是否找到該點數
    if (target_r == -1) {
        printf("找不到寶箱\\n");
        return 0;
    }

    int sum = 0;    // 用於累加鄰居點數
    int count = 0;  // 用於計算有效鄰居個數
    // 定義上下左右四個方向的位移量
    int dr[] = {-1, 1, 0, 0};
    int dc[] = {0, 0, -1, 1};

    // 檢查四個方向的鄰居
    for (int i = 0; i < 4; i++) {
        int nr = target_r + dr[i]; // 鄰居的列座標
        int nc = target_c + dc[i]; // 鄰居的行座標

        // 判斷鄰居是否在邊界內（不計入邊界外的格子）
        if (nr >= 0 && nr < n && nc >= 0 && nc < m) {
            sum += map[nr][nc];
            count++;
        }
    }

    // 計算平均值（整數除法會自動執行無條件捨去）
    int avg = sum / count;

    // 開啟階段：比較平均值與關鍵點數
    if (avg > k) {
        printf("成功開啟寶箱\\n");
    } else {
        printf("無法開啟寶箱\\n");
    }

    return 0;
}`

const highlightedCode = computed(() => {
  // 先轉義 HTML 以防萬一
  let html = code
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')

  // 使用佔位符避免重複匹配
  const placeholders = []
  
  // 1. 處理註解
  html = html.replace(/\/\/.*$/gm, (match) => {
    const id = `__COMMENT_${placeholders.length}__`
    placeholders.push(`<span class="text-slate-500 italic">${match}</span>`)
    return id
  })

  // 2. 處理字串 (雙引號)
  html = html.replace(/\".*?\"/g, (match) => {
    const id = `__STRING_${placeholders.length}__`
    placeholders.push(`<span class="text-amber-300 font-medium">${match}</span>`)
    return id
  })

  // 3. 處理關鍵字
  html = html.replace(/\b(include|int|if|for|return|break|printf|scanf|main|else)\b/g, (match) => {
    return `<span class="text-blue-400 font-bold">${match}</span>`
  })

  // 4. 處理標點與符號 (簡單上色)
  html = html.replace(/#\w+/g, '<span class="text-indigo-400">$&</span>')
  html = html.replace(/&amp;[a-z_]+/g, '<span class="text-emerald-400">$&</span>')

  // 5. 還原佔位符
  placeholders.forEach((content, i) => {
    const id = new RegExp(`__(COMMENT|STRING)_${i}__`, 'g')
    html = html.replace(id, content)
  })

  return html
})

const copied = ref(false)
const copyCode = () => {
  navigator.clipboard.writeText(code)
  copied.value = true
  setTimeout(() => (copied.value = false), 2000)
}
</script>

<template>
  <div class="max-w-4xl mx-auto space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
    
    <!-- 程式碼顯示區塊 -->
    <div class="bg-slate-900 rounded-3xl shadow-2xl overflow-hidden border border-slate-800">
      <div class="bg-slate-800/50 px-6 py-3 border-b border-slate-700 flex justify-between items-center">
        <div class="flex gap-1.5">
          <div class="w-3 h-3 rounded-full bg-red-500/80"></div>
          <div class="w-3 h-3 rounded-full bg-amber-500/80"></div>
          <div class="w-3 h-3 rounded-full bg-green-500/80"></div>
        </div>
        <div class="text-xs font-mono text-slate-400">solution.c</div>
        <button 
          @click="copyCode"
          class="flex items-center gap-2 px-3 py-1 bg-white/10 hover:bg-white/20 rounded-lg transition-all text-xs text-slate-300 font-medium active:scale-95"
        >
          <svg v-if="!copied" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg>
          <svg v-else xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-green-400"><polyline points="20 6 9 17 4 12"/></svg>
          {{ copied ? '已複製！' : '複製程式碼' }}
        </button>
      </div>
      
      <div class="p-6 overflow-x-auto text-sm md:text-base custom-scrollbar bg-[#0d1117]">
        <pre class="font-mono leading-relaxed"><code class="text-slate-300"><span v-html="highlightedCode"></span></code></pre>
      </div>
    </div>

  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: #0f172a;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #334155;
  border-radius: 20px;
}
pre {
  margin: 0;
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style>
