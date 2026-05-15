<script setup>
import { ref } from 'vue'

const activeSubTab = ref('string-func')

const subTabs = [
  { id: 'string-func', name: '字串處理函式' },
  { id: 'conversion-func', name: '數值轉換函式' }
]

const codeSnippets = {
  strcpy: `char src[] = "Hello";
char dest[20];
strcpy(dest, src); // 將 src 複製到 dest`,
  strcat: `char str1[20] = "Hello ";
char str2[] = "World";
strcat(str1, str2); // 將 str2 接在 str1 後面`,
  strtok: `char str[] = "apple,banana,cherry";
char *token = strtok(str, ",");
while (token != NULL) {
    printf("%s\\n", token);
    token = strtok(NULL, ",");
}`,
  strchr: `char str[] = "Hello";
char *ptr = strchr(str, 'l'); // 找第一個 'l' 的位置`,
  strtod: `char str[] = "3.14159 is pi";
char *endptr;
double val = strtod(str, &endptr); // 將字串轉為 double`
}
</script>

<template>
  <div class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
    
    <!-- Sub-Tabs -->
    <div class="flex justify-center border-b border-slate-200">
      <nav class="flex space-x-8" aria-label="Tabs">
        <button
          v-for="tab in subTabs"
          :key="tab.id"
          @click="activeSubTab = tab.id"
          :class="[
            activeSubTab === tab.id
              ? 'border-blue-500 text-blue-600 font-bold'
              : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300',
            'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-lg transition-all cursor-pointer'
          ]"
        >
          {{ tab.name }}
        </button>
      </nav>
    </div>

    <!-- Content Area: String Functions -->
    <div v-if="activeSubTab === 'string-func'" class="space-y-8 animate-in">
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        
        <!-- Instructional Content -->
        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-slate-800">
              <span class="w-8 h-8 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center text-sm">📚</span>
              String.h 函式庫
            </h3>
            <p class="text-slate-600 leading-relaxed mb-6">
              在 C 語言中，處理字串需要包含 <code>&lt;string.h&gt;</code> 標頭檔。以下是常用的字串處理函式：
            </p>
            
            <div class="space-y-6">
              <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-6 space-y-4">
                <div>
                  <p class="text-lg font-bold text-blue-800 mb-1">strcpy (String Copy)</p>
                  <p class="text-sm text-slate-600">用於將來源字串複製到目的字串陣列中。注意目的陣列大小必須足夠容納來源字串及結尾的空字元 <code>\0</code>。</p>
                </div>
                <div class="bg-white/70 p-4 rounded-xl border border-blue-100">
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">標準語法</p>
                  <code class="block text-sm text-slate-800 font-mono bg-slate-50 p-2 rounded border border-slate-100">char *strcpy(char *dest, const char *src);</code>
                </div>
                <div>
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">參數解釋</p>
                  <ul class="text-sm text-slate-600 space-y-1.5 ml-1">
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">dest</code>：目的字串陣列的指標。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">src</code>：來源字串的指標。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><strong>回傳值</strong>：回傳 <code>dest</code> 的指標。</span></li>
                  </ul>
                </div>
              </div>

              <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-6 space-y-4">
                <div>
                  <p class="text-lg font-bold text-blue-800 mb-1">strcat (String Concatenate)</p>
                  <p class="text-sm text-slate-600">用於將來源字串連接到目的字串的末尾。目的字串陣列必須有足夠空間容納合併後的字串。</p>
                </div>
                <div class="bg-white/70 p-4 rounded-xl border border-blue-100">
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">標準語法</p>
                  <code class="block text-sm text-slate-800 font-mono bg-slate-50 p-2 rounded border border-slate-100">char *strcat(char *dest, const char *src);</code>
                </div>
                <div>
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">參數解釋</p>
                  <ul class="text-sm text-slate-600 space-y-1.5 ml-1">
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">dest</code>：目的字串的指標（會被附加新內容）。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">src</code>：要附加在後面的來源字串。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><strong>回傳值</strong>：回傳 <code>dest</code> 的指標。</span></li>
                  </ul>
                </div>
              </div>

              <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-6 space-y-4">
                <div>
                  <p class="text-lg font-bold text-blue-800 mb-1">strchr (String Character Search)</p>
                  <p class="text-sm text-slate-600">搜尋字串中第一次出現指定字元的位置，並回傳指向該字元的指標。</p>
                </div>
                <div class="bg-white/70 p-4 rounded-xl border border-blue-100">
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">標準語法</p>
                  <code class="block text-sm text-slate-800 font-mono bg-slate-50 p-2 rounded border border-slate-100">char *strchr(const char *str, int c);</code>
                </div>
                <div>
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">參數解釋</p>
                  <ul class="text-sm text-slate-600 space-y-1.5 ml-1">
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">str</code>：要被搜尋的字串。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">c</code>：要搜尋的字元（以 ASCII 碼的形式傳入，也可直接寫字元如 <code>'a'</code>）。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><strong>回傳值</strong>：回傳指向找到字元位置的指標，若找不到則回傳 <code>NULL</code>。</span></li>
                  </ul>
                </div>
              </div>

              <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-6 space-y-4">
                <div>
                  <p class="text-lg font-bold text-blue-800 mb-1">strtok (String Tokenize)</p>
                  <p class="text-sm text-slate-600">根據指定的分隔符號將字串切割成多個子字串（Tokens）。</p>
                </div>
                <div class="bg-white/70 p-4 rounded-xl border border-blue-100">
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">標準語法</p>
                  <code class="block text-sm text-slate-800 font-mono bg-slate-50 p-2 rounded border border-slate-100">char *strtok(char *str, const char *delim);</code>
                </div>
                <div>
                  <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">參數解釋</p>
                  <ul class="text-sm text-slate-600 space-y-1.5 ml-1">
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">str</code>：要切割的字串。<br><strong>注意：</strong>只有第一次呼叫需傳入字串，後續呼叫欲切割同個字串時需傳入 <code>NULL</code>。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><code class="text-blue-600 bg-blue-50 px-1 rounded">delim</code>：包含所有分隔符號字元的字串（例如：<code>" ,."</code> 表示空格、逗號或句號都會被當成分隔符號）。</span></li>
                    <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span><span><strong>回傳值</strong>：回傳指向下一個子字串的指標，若已無子字串則回傳 <code>NULL</code>。</span></li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Code Snippets -->
        <div class="space-y-6">
          <div class="bg-slate-900 rounded-[2rem] p-8 font-mono text-sm shadow-2xl overflow-hidden relative">
            <div class="absolute top-4 right-6 text-slate-500 text-xs uppercase font-bold tracking-widest">Example Code</div>
            <pre class="text-indigo-400"><code><span class="text-pink-400">#include</span> &lt;string.h&gt;

<span class="text-slate-500">// strcpy 範例</span>
<span class="text-white">{{ codeSnippets.strcpy }}</span>

<span class="text-slate-500">// strcat 範例</span>
<span class="text-white">{{ codeSnippets.strcat }}</span>

<span class="text-slate-500">// strchr 範例</span>
<span class="text-white">{{ codeSnippets.strchr }}</span>

<span class="text-slate-500">// strtok 範例</span>
<span class="text-white">{{ codeSnippets.strtok }}</span></code></pre>
          </div>
        </div>
      </div>
    </div>

    <!-- Content Area: Conversion Functions -->
    <div v-if="activeSubTab === 'conversion-func'" class="space-y-8 animate-in">
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        
        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-slate-800">
              <span class="w-8 h-8 bg-purple-100 text-purple-600 rounded-lg flex items-center justify-center text-sm">⚙️</span>
              Stdlib.h 函式庫
            </h3>
            <p class="text-slate-600 leading-relaxed mb-6">
              數值轉換函式通常定義在 <code>&lt;stdlib.h&gt;</code> 中。
            </p>
            
            <div class="bg-purple-50/50 border border-purple-100 rounded-2xl p-6 space-y-4">
              <div>
                <p class="text-lg font-bold text-purple-800 mb-1">strtod (String to Double)</p>
                <p class="text-sm text-slate-600 leading-relaxed">
                  將字串轉換為倍精度浮點數（double）。它比 <code>atof</code> 更強大，因為它可以告訴你轉換在哪裡停止。
                </p>
              </div>
              <div class="bg-white/70 p-4 rounded-xl border border-purple-100">
                <p class="text-xs font-bold text-purple-700 mb-2 tracking-wide uppercase">標準語法</p>
                <code class="block text-sm text-slate-800 font-mono bg-slate-50 p-2 rounded border border-slate-100">double strtod(const char *str, char **endptr);</code>
              </div>
              <div>
                <p class="text-xs font-bold text-purple-700 mb-2 tracking-wide uppercase">參數解釋</p>
                <ul class="text-sm text-slate-600 space-y-1.5 ml-1">
                  <li class="flex items-start gap-2"><span class="text-purple-400 mt-0.5">•</span><span><code class="text-purple-600 bg-purple-50 px-1 rounded">str</code>：要轉換為浮點數的字串。</span></li>
                  <li class="flex items-start gap-2"><span class="text-purple-400 mt-0.5">•</span><span><code class="text-purple-600 bg-purple-50 px-1 rounded">endptr</code>：指標的指標。用來存放轉換停止後的剩餘字串位置。若不在乎剩餘字串可傳入 <code>NULL</code>。</span></li>
                  <li class="flex items-start gap-2"><span class="text-purple-400 mt-0.5">•</span><span><strong>回傳值</strong>：回傳轉換成功後的 <code>double</code> 數值；若無法轉換則回傳 <code>0.0</code>。</span></li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <div class="space-y-6">
          <div class="bg-slate-900 rounded-[2rem] p-8 font-mono text-sm shadow-2xl overflow-hidden relative">
            <div class="absolute top-4 right-6 text-slate-500 text-xs uppercase font-bold tracking-widest">Example Code</div>
            <pre class="text-indigo-400"><code><span class="text-pink-400">#include</span> &lt;stdlib.h&gt;
<span class="text-pink-400">#include</span> &lt;stdio.h&gt;

<span class="text-slate-500">// strtod 範例</span>
<span class="text-white">{{ codeSnippets.strtod }}</span>

<span class="text-slate-500">// 輸出結果</span>
<span class="text-white">Value: 3.141590
Remaining part: " is pi"</span></code></pre>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<style scoped>
.animate-in {
  animation: slideIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes slideIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
