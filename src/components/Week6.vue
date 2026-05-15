<script setup>
import { ref } from 'vue'
import BubbleSortSimulator from './BubbleSortSimulator.vue'

const activeSubTab = ref('bubble-desc')

const subTabs = [
  { id: 'bubble-desc', name: 'Bubble Sort (由大到小)' }
]
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

    <!-- Content Area -->
    <div v-if="activeSubTab === 'bubble-desc'" class="space-y-8 animate-in">
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        
        <!-- Instructional Content -->
        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-slate-800">
              <span class="w-8 h-8 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center text-sm">💡</span>
              演算法重點：由大到小 (Descending)
            </h3>
            <p class="text-slate-600 leading-relaxed mb-6">
              在由大到小的排序中，我們的目標是將<strong>較小的數字</strong>往右邊推（像氣泡一樣浮到末端），讓<strong>較大的數字</strong>留在左邊。
            </p>
            <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-6 space-y-4">
              <p class="text-sm font-bold text-blue-800">核心邏輯：</p>
              <ul class="space-y-3 text-sm text-slate-600">
                <li class="flex items-start gap-2">
                  <span class="text-blue-500 font-bold mt-1">●</span>
                  比較相鄰的兩個元素 <code>arr[j]</code> 與 <code>arr[j+1]</code>。
                </li>
                <li class="flex items-start gap-2">
                  <span class="text-blue-500 font-bold mt-1">●</span>
                  若 <code>arr[j] &lt; arr[j+1]</code>，則交換它們的位置（因為較大的數應該在左邊）。
                </li>
                <li class="flex items-start gap-2">
                  <span class="text-blue-500 font-bold mt-1">●</span>
                  每一輪結束後，該輪的<strong>最小值</strong>會被推到最後面（正確位置）。
                </li>
              </ul>
            </div>
          </div>

          <!-- Code Snippet -->
          <div class="bg-slate-900 rounded-[2rem] p-8 font-mono text-sm shadow-2xl overflow-hidden relative group">
             <div class="absolute top-4 right-6 text-slate-500 text-xs uppercase font-bold tracking-widest">C Language</div>
             <p class="text-indigo-400"><span class="text-pink-400">void</span> bubbleSortDescending(<span class="text-pink-400">int</span> arr[], <span class="text-pink-400">int</span> n) {</p>
             <p class="pl-4 text-slate-500 mt-2">// 外層迴圈控制執行幾輪</p>
             <p class="pl-4 text-indigo-400">for (<span class="text-pink-400">int</span> i = 0; i &lt; n - 1; i++) {</p>
             <p class="pl-8 text-slate-500 mt-2">// 內層迴圈進行相鄰比較</p>
             <p class="pl-8 text-indigo-400">for (<span class="text-pink-400">int</span> j = 0; j &lt; n - i - 1; j++) {</p>
             <p class="pl-12 text-slate-300 mt-2">if (arr[j] <span class="text-yellow-400 font-bold">&lt;</span> arr[j + 1]) {</p>
             <p class="pl-16 text-slate-500">// 交換位置：將較大的數字換到前面</p>
             <p class="pl-16 text-white">int temp = arr[j];</p>
             <p class="pl-16 text-white">arr[j] = arr[j + 1];</p>
             <p class="pl-16 text-white">arr[j + 1] = temp;</p>
             <p class="pl-12 text-slate-300">}</p>
             <p class="pl-8 text-indigo-400">}</p>
             <p class="pl-4 text-indigo-400">}</p>
             <p class="text-indigo-400">}</p>
          </div>
        </div>

        <!-- Simulator -->
        <div class="space-y-6">
           <BubbleSortSimulator :isDescending="true" />
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
