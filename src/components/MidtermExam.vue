<script setup>
import { ref } from 'vue'

const activeQuestion = ref('q1')

const questions = [
  { id: 'q1', name: '第一題：3n+1 問題' },
  { id: 'q2', name: '第二題：轉置矩陣' },
  { id: 'q3', name: '第三題：學生成績排名' }
]
</script>

<template>
  <div class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">

    <!-- Sub-Tabs -->
    <div class="flex justify-center border-b border-slate-200">
      <nav class="flex space-x-8" aria-label="Tabs">
        <button
          v-for="q in questions"
          :key="q.id"
          @click="activeQuestion = q.id"
          :class="[
            activeQuestion === q.id
              ? 'border-amber-500 text-amber-600 font-bold'
              : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300',
            'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-lg transition-all cursor-pointer'
          ]"
        >
          {{ q.name }}
        </button>
      </nav>
    </div>

    <!-- Q1: 3n+1 -->
    <div v-if="activeQuestion === 'q1'" class="space-y-8 animate-in">
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-slate-800">
              <span class="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-sm">1</span>
              3n+1 問題
            </h3>
            <div class="text-slate-600 leading-relaxed space-y-4">
              <p>考慮以下的演算法：</p>
              <ol class="list-decimal ml-5 space-y-1 text-sm">
                <li>輸入 n</li>
                <li>印出 n</li>
                <li>如果 n = 1 結束</li>
                <li>如果 n 是奇數 那麼 n = 3*n+1</li>
                <li>否則 n = n/2</li>
                <li>GOTO 2</li>
              </ol>
              <p class="text-sm">例如輸入 22，得到的數列：22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1</p>
              <p class="text-sm">此數列的長度稱為 n 的 <strong>cycle-length</strong>。22 的 cycle length 為 16。</p>
              <p class="text-sm">對任 2 個整數 i、j，想要知道介於 i、j（包含 i、j）之間的數所產生的數列中<strong>最大的 cycle length</strong> 是多少。</p>
            </div>
          </div>

          <div class="bg-amber-50/50 border border-amber-100 rounded-2xl p-6 space-y-4">
            <div>
              <p class="text-xs font-bold text-amber-700 mb-2 tracking-wide uppercase">Input Description</p>
              <p class="text-sm text-slate-600">輸入一筆測試資料 i、j（0 &lt; i, j &lt; 1,000,000）</p>
              <p class="text-sm text-slate-600 mt-1">若 i &gt; j，使用<strong>指標</strong>做交換</p>
            </div>
            <div>
              <p class="text-xs font-bold text-amber-700 mb-2 tracking-wide uppercase">Output Description</p>
              <p class="text-sm text-slate-600">輸出 i, j 和介於 i, j 之間的數所產生的數列中最大的 cycle length。</p>
            </div>
          </div>

          <!-- Sample I/O -->
          <div class="bg-slate-900 rounded-2xl p-6 font-mono text-sm shadow-xl">
            <div class="text-slate-500 text-xs uppercase font-bold tracking-widest mb-4">Sample I/O</div>
            <p class="text-green-400 text-xs mb-1">// Input</p>
            <p class="text-white">1 10</p>
            <div class="h-px w-full bg-slate-700 my-4"></div>
            <p class="text-green-400 text-xs mb-1">// Output</p>
            <p class="text-white">1 10 20</p>
          </div>
        </div>

        <!-- Answer Section -->
        <div class="space-y-6">
            <div class="bg-slate-900 rounded-[2rem] p-8 font-mono text-sm shadow-2xl overflow-hidden relative">
              <div class="absolute top-4 right-6 text-slate-500 text-xs uppercase font-bold tracking-widest">Solution</div>
<pre class="text-indigo-400 leading-relaxed"><code><span class="text-pink-400">#include</span> <span class="text-green-400">&lt;stdio.h&gt;</span>

<span class="text-pink-400">void</span> <span class="text-blue-400">swap</span>(<span class="text-pink-400">int</span> *a, <span class="text-pink-400">int</span> *b) {
    <span class="text-pink-400">int</span> temp = *a;
    *a = *b;
    *b = temp;
}

<span class="text-pink-400">int</span> <span class="text-blue-400">main</span>(<span class="text-pink-400">void</span>) {
    <span class="text-pink-400">int</span> i, j;

    <span class="text-pink-400">if</span> (scanf(<span class="text-green-400">"%d %d"</span>, &amp;i, &amp;j) == <span class="text-yellow-400">2</span>) {

        <span class="text-pink-400">int</span> orig_i = i;
        <span class="text-pink-400">int</span> orig_j = j;

        <span class="text-pink-400">if</span> (i > j) {
            <span class="text-blue-400">swap</span>(&amp;i, &amp;j);
        }

        <span class="text-pink-400">int</span> max_cycle_length = <span class="text-yellow-400">0</span>;

        <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> k = i; k &lt;= j; k++) {

            <span class="text-pink-400">long long</span> n = k;
            <span class="text-pink-400">int</span> current_length = <span class="text-yellow-400">1</span>;

            <span class="text-pink-400">while</span> (n != <span class="text-yellow-400">1</span>) {
                <span class="text-pink-400">if</span> (n % <span class="text-yellow-400">2</span> != <span class="text-yellow-400">0</span>) {
                    n = <span class="text-yellow-400">3</span> * n + <span class="text-yellow-400">1</span>;
                } <span class="text-pink-400">else</span> {
                    n = n / <span class="text-yellow-400">2</span>;
                }
                current_length++;
            }

            <span class="text-pink-400">if</span> (current_length > max_cycle_length) {
                max_cycle_length = current_length;
            }
        }

        printf(<span class="text-green-400">"%d %d %d\n"</span>, orig_i, orig_j, max_cycle_length);
    }

    <span class="text-pink-400">return</span> <span class="text-yellow-400">0</span>;
}</code></pre>
            </div>
        </div>
      </div>
    </div>

    <!-- Q2: Transpose Matrix -->
    <div v-if="activeQuestion === 'q2'" class="space-y-8 animate-in">
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-slate-800">
              <span class="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-sm">2</span>
              轉置矩陣
            </h3>
            <div class="text-slate-600 leading-relaxed space-y-4">
              <p>已知一 (m × n) 矩陣 A，將 A 中之行與列調換的矩陣，稱為<strong>轉置矩陣</strong>。</p>
              <div class="grid grid-cols-2 gap-4 my-4">
                <div class="bg-slate-50 p-4 rounded-xl border border-slate-100">
                  <p class="text-xs font-bold text-slate-400 mb-2">矩陣 A (2×3)</p>
                  <div class="font-mono text-sm space-y-1">
                    <p>3  1  2</p>
                    <p>8  5  4</p>
                  </div>
                </div>
                <div class="bg-amber-50 p-4 rounded-xl border border-amber-100">
                  <p class="text-xs font-bold text-amber-500 mb-2">轉置 Aᵀ (3×2)</p>
                  <div class="font-mono text-sm space-y-1">
                    <p>3  8</p>
                    <p>1  5</p>
                    <p>2  4</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="bg-amber-50/50 border border-amber-100 rounded-2xl p-6 space-y-4">
            <div>
              <p class="text-xs font-bold text-amber-700 mb-2 tracking-wide uppercase">Input Description</p>
              <p class="text-sm text-slate-600">第一行：列(row)&lt;100 和 行(column)&lt;100，緊接著是矩陣的內容</p>
            </div>
            <div>
              <p class="text-xs font-bold text-amber-700 mb-2 tracking-wide uppercase">Output Description</p>
              <p class="text-sm text-slate-600">直接輸出翻轉後的矩陣</p>
            </div>
          </div>

          <!-- Samples -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="bg-slate-900 rounded-2xl p-6 font-mono text-sm shadow-xl">
              <div class="text-slate-500 text-xs uppercase font-bold tracking-widest mb-4">Sample 1</div>
              <p class="text-green-400 text-xs mb-1">// Input</p>
              <p class="text-white">3 3</p>
              <p class="text-white">1 2 3</p>
              <p class="text-white">4 5 6</p>
              <p class="text-white">7 8 9</p>
              <div class="h-px w-full bg-slate-700 my-3"></div>
              <p class="text-green-400 text-xs mb-1">// Output</p>
              <p class="text-white">1 4 7</p>
              <p class="text-white">2 5 8</p>
              <p class="text-white">3 6 9</p>
            </div>
            <div class="bg-slate-900 rounded-2xl p-6 font-mono text-sm shadow-xl">
              <div class="text-slate-500 text-xs uppercase font-bold tracking-widest mb-4">Sample 2</div>
              <p class="text-green-400 text-xs mb-1">// Input</p>
              <p class="text-white">2 3</p>
              <p class="text-white">3 1 2</p>
              <p class="text-white">8 5 4</p>
              <div class="h-px w-full bg-slate-700 my-3"></div>
              <p class="text-green-400 text-xs mb-1">// Output</p>
              <p class="text-white">3 8</p>
              <p class="text-white">1 5</p>
              <p class="text-white">2 4</p>
            </div>
          </div>
        </div>

        <!-- Answer -->
        <div class="space-y-6">
            <div class="bg-slate-900 rounded-[2rem] p-8 font-mono text-sm shadow-2xl overflow-hidden relative">
              <div class="absolute top-4 right-6 text-slate-500 text-xs uppercase font-bold tracking-widest">Solution</div>
<pre class="text-indigo-400 leading-relaxed"><code><span class="text-pink-400">#include</span> <span class="text-green-400">&lt;stdio.h&gt;</span>

<span class="text-pink-400">int</span> <span class="text-blue-400">main</span>(<span class="text-pink-400">void</span>) {
    <span class="text-pink-400">int</span> row, col;

    <span class="text-pink-400">if</span> (scanf(<span class="text-green-400">"%d %d"</span>, &amp;row, &amp;col) != EOF) {
        <span class="text-pink-400">int</span> matrix[<span class="text-yellow-400">105</span>][<span class="text-yellow-400">105</span>];

        <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> i = <span class="text-yellow-400">0</span>; i &lt; row; i++) {
            <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> j = <span class="text-yellow-400">0</span>; j &lt; col; j++) {
                scanf(<span class="text-green-400">"%d"</span>, &amp;matrix[i][j]);
            }
        }

        <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> j = <span class="text-yellow-400">0</span>; j &lt; col; j++) {
            <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> i = <span class="text-yellow-400">0</span>; i &lt; row; i++) {
                printf(<span class="text-green-400">"%d"</span>, matrix[i][j]);
                <span class="text-pink-400">if</span> (i &lt; row - <span class="text-yellow-400">1</span>) {
                    printf(<span class="text-green-400">" "</span>);
                }
            }
            printf(<span class="text-green-400">"\n"</span>);
        }
    }

    <span class="text-pink-400">return</span> <span class="text-yellow-400">0</span>;
}</code></pre>
            </div>
        </div>
      </div>
    </div>

    <!-- Q3: Student Ranking -->
    <div v-if="activeQuestion === 'q3'" class="space-y-8 animate-in">
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-slate-800">
              <span class="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-sm">3</span>
              學生成績排名
            </h3>
            <div class="text-slate-600 leading-relaxed space-y-4">
              <p>班上共有 N 名學生，每位學生有 3 門課（計算機概論、微積分、邏輯設計）。</p>
              <p>請讀取 N × 3 二維陣列後計算每位學生的總分，最後輸出由<strong>氣泡排序大到小</strong>排序後的成績單。</p>
            </div>
          </div>

          <div class="bg-amber-50/50 border border-amber-100 rounded-2xl p-6 space-y-4">
            <div>
              <p class="text-xs font-bold text-amber-700 mb-2 tracking-wide uppercase">Input Description</p>
              <p class="text-sm text-slate-600">第一行：整數 N (1 ≤ N ≤ 60)</p>
              <p class="text-sm text-slate-600 mt-1">之後：N × 3 二維陣列儲存成績</p>
            </div>
            <div>
              <p class="text-xs font-bold text-amber-700 mb-2 tracking-wide uppercase">Output Description</p>
              <p class="text-sm text-slate-600">格式：排名 學生編號 總分（數字間隔 4 個空白）</p>
              <p class="text-sm text-red-500 mt-1 font-bold">⚠ 請勿使用 \t，會無法判定 AC</p>
            </div>
          </div>

          <div class="bg-slate-900 rounded-2xl p-6 font-mono text-sm shadow-xl">
            <div class="text-slate-500 text-xs uppercase font-bold tracking-widest mb-4">Sample I/O</div>
            <p class="text-green-400 text-xs mb-1">// Input</p>
            <p class="text-white">3</p>
            <p class="text-white">86 75 90</p>
            <p class="text-white">79 66 73</p>
            <p class="text-white">77 83 65</p>
            <div class="h-px w-full bg-slate-700 my-3"></div>
            <p class="text-green-400 text-xs mb-1">// Output</p>
            <p class="text-white">排名 學生編號 總分</p>
            <p class="text-white">1    1    251</p>
            <p class="text-white">2    3    225</p>
            <p class="text-white">3    2    218</p>
          </div>

          <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-5">
            <p class="text-xs font-bold text-blue-700 mb-2 tracking-wide uppercase">💡 Hint</p>
            <ul class="text-sm text-slate-600 space-y-2">
              <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span>使用氣泡排序法做總分排序</li>
              <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span>對總分做排序之後，請一起將學生編號做交換</li>
              <li class="flex items-start gap-2"><span class="text-blue-400 mt-0.5">•</span>交換不強制使用指標</li>
            </ul>
          </div>
        </div>

        <!-- Answer -->
        <div class="space-y-6">
            <div class="bg-slate-900 rounded-[2rem] p-8 font-mono text-sm shadow-2xl overflow-hidden relative">
              <div class="absolute top-4 right-6 text-slate-500 text-xs uppercase font-bold tracking-widest">Solution</div>
<pre class="text-indigo-400 leading-relaxed"><code><span class="text-pink-400">#include</span> <span class="text-green-400">&lt;stdio.h&gt;</span>

<span class="text-pink-400">int</span> <span class="text-blue-400">main</span>(<span class="text-pink-400">void</span>) {
    <span class="text-pink-400">int</span> N;
    scanf(<span class="text-green-400">"%d"</span>, &amp;N);

    <span class="text-pink-400">int</span> scores[<span class="text-yellow-400">60</span>][<span class="text-yellow-400">3</span>];
    <span class="text-pink-400">int</span> totals[<span class="text-yellow-400">60</span>];
    <span class="text-pink-400">int</span> ids[<span class="text-yellow-400">60</span>];

    <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> i = <span class="text-yellow-400">0</span>; i &lt; N; i++) {
        <span class="text-pink-400">int</span> sum = <span class="text-yellow-400">0</span>;
        <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> j = <span class="text-yellow-400">0</span>; j &lt; <span class="text-yellow-400">3</span>; j++) {
            scanf(<span class="text-green-400">"%d"</span>, &amp;scores[i][j]);
            sum += scores[i][j];
        }
        ids[i] = i + <span class="text-yellow-400">1</span>;
        totals[i] = sum;
    }

    <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> i = <span class="text-yellow-400">0</span>; i &lt; N - <span class="text-yellow-400">1</span>; i++) {
        <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> j = <span class="text-yellow-400">0</span>; j &lt; N - <span class="text-yellow-400">1</span> - i; j++) {
            <span class="text-pink-400">if</span> (totals[j] &lt; totals[j + <span class="text-yellow-400">1</span>]) {
                <span class="text-pink-400">int</span> tempTotal = totals[j];
                totals[j] = totals[j + <span class="text-yellow-400">1</span>];
                totals[j + <span class="text-yellow-400">1</span>] = tempTotal;

                <span class="text-pink-400">int</span> tempId = ids[j];
                ids[j] = ids[j + <span class="text-yellow-400">1</span>];
                ids[j + <span class="text-yellow-400">1</span>] = tempId;
            }
        }
    }

    printf(<span class="text-green-400">"排名 學生編號 總分\n"</span>);
    <span class="text-pink-400">for</span> (<span class="text-pink-400">int</span> i = <span class="text-yellow-400">0</span>; i &lt; N; i++) {
        printf(<span class="text-green-400">"%d    %d    %d\n"</span>, i + <span class="text-yellow-400">1</span>, ids[i], totals[i]);
    }

    <span class="text-pink-400">return</span> <span class="text-yellow-400">0</span>;
}</code></pre>
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
