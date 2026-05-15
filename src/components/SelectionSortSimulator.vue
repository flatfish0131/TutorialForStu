<script setup>
import { ref, watch, nextTick, onUnmounted, computed } from 'vue'

const originalArray = ref([64, 34, 25, 12, 22, 11, 90])
const array = ref([...originalArray.value])
const arrayIds = ref(array.value.map((_, index) => index))
const inputValue = ref(originalArray.value.join(', '))

// 演算法狀態
const i = ref(0)       // 外迴圈 (目前要放最小值的位置)
const j = ref(0)       // 內迴圈 (掃描用)
const minIdx = ref(0)  // 目前找到的最小值索引

const status = ref('idle')
// compare: 正在掃描比較, found: 找到新的最小值, swap: 準備交換, next: 進入下一輪
const phase = ref('compare')
const logs = ref([])
const isPlaying = ref(false)
const logContainer = ref(null)
let playInterval = null

const arrayObj = computed(() => {
  return array.value.map((val, index) => ({
    value: val,
    index: index,
    id: arrayIds.value[index]
  }))
})

const generateRandomArray = () => {
  const length = Math.floor(Math.random() * 5) + 6
  const newArr = Array.from({ length }, () => Math.floor(Math.random() * 80) + 10)
  originalArray.value = [...newArr]
  inputValue.value = newArr.join(', ')
  resetSimulation(newArr)
}

const handleArrayInputChange = () => {
  const parsed = inputValue.value
    .split(',')
    .map(s => parseInt(s.trim()))
    .filter(n => !isNaN(n))
  if (parsed.length > 0) {
    originalArray.value = [...parsed]
    resetSimulation(parsed)
  }
}

const resetSimulation = (currentArray = originalArray.value) => {
  array.value = [...currentArray]
  arrayIds.value = array.value.map((_, index) => Date.now() + index)
  i.value = 0
  j.value = 0
  minIdx.value = 0
  status.value = 'idle'
  phase.value = 'compare'
  logs.value = []
  isPlaying.value = false
}

const addLog = (message, type = 'normal') => {
  logs.value.push({ id: Date.now() + Math.random(), message, type })
}

watch(logs, async () => {
  await nextTick()
  if (logContainer.value) {
    logContainer.value.scrollTop = logContainer.value.scrollHeight
  }
}, { deep: true })

const swapElements = (idx1, idx2) => {
  const tempVal = array.value[idx1]
  array.value[idx1] = array.value[idx2]
  array.value[idx2] = tempVal
  const tempId = arrayIds.value[idx1]
  arrayIds.value[idx1] = arrayIds.value[idx2]
  arrayIds.value[idx2] = tempId
}

const nextStep = () => {
  if (status.value === 'finished') return

  if (status.value === 'idle') {
    status.value = 'running'
    j.value = i.value + 1
    minIdx.value = i.value
    addLog(`開始選擇排序！目標是每一輪找到最小值，放到正確位置。`, 'info')
    addLog(`--- 開始第 1 輪：假設最小值在索引 ${i.value} (值=${array.value[i.value]}) ---`, 'info')
    phase.value = 'compare'
    return
  }

  if (i.value >= array.value.length - 1) {
    status.value = 'finished'
    isPlaying.value = false
    addLog(`🎉 排序完成！所有的元素皆已到位。`, 'success')
    return
  }

  if (phase.value === 'compare') {
    if (j.value < array.value.length) {
      const valJ = array.value[j.value]
      const valMin = array.value[minIdx.value]
      if (valJ < valMin) {
        addLog(`掃描索引 ${j.value} (${valJ})：發現 ${valJ} < 目前最小值 ${valMin}，更新最小值索引為 ${j.value}！`, 'warning')
        minIdx.value = j.value
      } else {
        addLog(`掃描索引 ${j.value} (${valJ})：${valJ} >= 目前最小值 ${valMin}，繼續掃描。`, 'normal')
      }
      j.value++
    } else {
      // 內迴圈結束，準備交換
      phase.value = 'swap'
      if (minIdx.value !== i.value) {
        addLog(`掃描結束！最小值 ${array.value[minIdx.value]} 在索引 ${minIdx.value}，準備與索引 ${i.value} (${array.value[i.value]}) 交換。`, 'warning')
      } else {
        addLog(`掃描結束！索引 ${i.value} (${array.value[i.value]}) 已經是最小值，不需要交換。`, 'normal')
      }
    }
  } else if (phase.value === 'swap') {
    if (minIdx.value !== i.value) {
      const val1 = array.value[i.value]
      const val2 = array.value[minIdx.value]
      swapElements(i.value, minIdx.value)
      addLog(`已完成交換：${val1} 和 ${val2} 互換位置。`, 'error')
    }

    const sortedVal = array.value[i.value]
    addLog(`這輪結束，值 ${sortedVal} 已放到正確位置 (索引 ${i.value})！`, 'success')

    i.value++
    if (i.value >= array.value.length - 1) {
      status.value = 'finished'
      isPlaying.value = false
      addLog(`🎉 排序完成！所有的元素皆已到位。`, 'success')
    } else {
      j.value = i.value + 1
      minIdx.value = i.value
      phase.value = 'compare'
      addLog(`--- 開始第 ${i.value + 1} 輪：假設最小值在索引 ${i.value} (值=${array.value[i.value]}) ---`, 'info')
    }
  }
}

const togglePlay = () => {
  isPlaying.value = !isPlaying.value
}

watch(() => [isPlaying.value, status.value], () => {
  clearInterval(playInterval)
  if (isPlaying.value && status.value !== 'finished') {
    playInterval = setInterval(() => {
      nextStep()
    }, 800)
  }
})

onUnmounted(() => {
  clearInterval(playInterval)
})

const getBoxStyle = (index) => {
  if (status.value === 'finished') {
    return "bg-green-100 border-green-500 text-green-800 shadow-md"
  }
  // 已排好的 (左側)
  if (index < i.value) {
    return "bg-green-100 border-green-500 text-green-800 opacity-90"
  }
  // 交換階段：高亮 i 和 minIdx
  if (phase.value === 'swap' && (index === i.value || index === minIdx.value)) {
    return "bg-red-200 border-red-500 text-red-900 scale-110 shadow-lg z-10"
  }
  // 目前最小值
  if (index === minIdx.value && status.value === 'running') {
    return "bg-orange-200 border-orange-400 text-orange-900 scale-105 shadow-md z-10"
  }
  // 目前掃描位置 j
  if (index === j.value - 1 && status.value === 'running' && phase.value === 'compare') {
    return "bg-yellow-200 border-yellow-400 text-yellow-900 scale-105 shadow-md z-10"
  }
  // 外迴圈 i 的位置
  if (index === i.value && status.value === 'running') {
    return "bg-blue-100 border-blue-400 text-blue-900"
  }
  return "bg-blue-50 border-blue-300 text-blue-900"
}

const getLogStyle = (type) => {
  switch (type) {
    case 'info': return 'bg-blue-50 border-blue-500 text-blue-800 font-bold'
    case 'success': return 'bg-green-50 border-green-500 text-green-800'
    case 'error': return 'bg-red-50 border-red-400 text-red-800'
    case 'warning': return 'bg-orange-50 border-orange-400 text-orange-800'
    default: return 'bg-slate-50 border-slate-300 text-slate-700'
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- 設定面板 -->
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 flex flex-col md:flex-row gap-6 items-center justify-between">
      <div class="flex-1 w-full space-y-4">
        <div>
          <label class="block text-sm font-medium text-slate-700 mb-1">自訂陣列 (可用逗號分隔輸入亂序數字)</label>
          <div class="flex items-center gap-4">
            <input
              type="text"
              v-model="inputValue"
              @input="handleArrayInputChange"
              :disabled="status !== 'idle'"
              class="flex-1 px-4 py-2 bg-slate-50 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:opacity-50"
              placeholder="例如: 64, 34, 25, 12, 22, 11, 90"
            />
            <button
              @click="generateRandomArray"
              :disabled="status !== 'idle'"
              class="flex items-center gap-2 px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg transition-colors disabled:opacity-50 whitespace-nowrap"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 3h5v5M4 20L21 3M21 16v5h-5M15 15l6 6M4 4l5 5"/></svg>
              隨機產生
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 視覺化陣列區塊 -->
    <div class="bg-white p-8 rounded-2xl shadow-sm border border-slate-200 overflow-x-auto min-h-[350px] flex flex-col items-center justify-center">
      <TransitionGroup name="list" tag="div" class="flex gap-2 md:gap-4 items-end relative h-72 pt-12">
        <div v-for="(item) in arrayObj" :key="item.id" class="flex flex-col items-center group relative">

          <!-- 指標箭頭 -->
          <div class="absolute -top-10 flex flex-col items-center justify-end h-8 w-full">
            <!-- i 指標 -->
            <span v-if="item.index === i && status !== 'finished' && status !== 'idle'"
                  class="text-blue-500 animate-bounce">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="none"><path d="M12 20l-8-8h16l-8 8z"/></svg>
            </span>
            <!-- j 指標 (掃描中) -->
            <span v-else-if="item.index === j - 1 && status === 'running' && phase === 'compare'"
                  class="text-yellow-500 animate-bounce">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="none"><path d="M12 20l-8-8h16l-8 8z"/></svg>
            </span>
          </div>

          <!-- 最小值標籤 -->
          <div class="absolute -top-16 flex flex-col items-center w-full">
            <span v-if="item.index === minIdx && status === 'running'"
                  class="text-[10px] font-black text-orange-600 bg-orange-100 px-2 py-0.5 rounded-full uppercase tracking-wider">
              MIN
            </span>
          </div>

          <!-- 陣列元素方塊 -->
          <div
            :class="['w-10 md:w-14 flex items-center justify-center text-sm md:text-lg font-bold border-2 rounded-t-xl transition-all duration-300', getBoxStyle(item.index)]"
            :style="{ height: Math.max(item.value * 2.2, 40) + 'px' }"
          >
            {{ item.value }}
          </div>

          <!-- 陣列索引 -->
          <div class="mt-2 text-xs md:text-sm text-slate-400 font-mono">
            {{ item.index }}
          </div>
        </div>
      </TransitionGroup>

      <!-- 狀態提示 -->
      <div class="mt-10 h-8 flex items-center justify-center">
        <div v-if="status === 'finished'" class="flex items-center gap-2 text-green-600 font-bold text-lg animate-pulse">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="M22 4L12 14.01l-3-3"/></svg>
          排序完成！所有元素皆已到達正確位置。
        </div>
      </div>
    </div>

    <!-- 控制面板 & 日誌區塊 -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <!-- 步驟按鈕 -->
      <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 flex flex-col justify-center gap-4">
        <h3 class="text-lg font-bold text-slate-800 mb-2">控制中心</h3>
        <button
          @click="nextStep"
          :disabled="status === 'finished' || isPlaying"
          class="flex items-center justify-center gap-2 w-full py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-colors disabled:bg-blue-300"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="6" y1="4" x2="6" y2="20"/><polygon points="10,4 20,12 10,20"/></svg>
          {{ status === 'idle' ? '開始模擬' : '下一步 (Next Step)' }}
        </button>
        <div class="flex gap-4">
          <button
            @click="togglePlay"
            :disabled="status === 'finished'"
            :class="['flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-medium transition-colors', isPlaying ? 'bg-amber-100 text-amber-700 hover:bg-amber-200' : 'bg-slate-100 text-slate-700 hover:bg-slate-200 disabled:opacity-50']"
          >
            <svg v-if="isPlaying" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="5 3 19 12 5 21 5 3"/></svg>
            {{ isPlaying ? '暫停' : '自動播放' }}
          </button>
          <button
            @click="resetSimulation(originalArray)"
            class="flex-1 flex items-center justify-center gap-2 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-medium transition-colors"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
            重新開始
          </button>
        </div>

        <!-- 圖例 -->
        <div class="mt-4 flex flex-col gap-2 text-sm text-slate-600 border-t pt-4">
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-blue-100 border-2 border-blue-400"></span> 起始位置 (i)</div>
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-yellow-200 border-2 border-yellow-400"></span> 正在掃描 (j)</div>
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-orange-200 border-2 border-orange-400"></span> 目前最小值 (min)</div>
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-red-200 border-2 border-red-500"></span> 交換中</div>
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-green-200 border-2 border-green-500"></span> 已排序完成</div>
        </div>
      </div>

      <!-- 執行紀錄 -->
      <div class="md:col-span-2 bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden flex flex-col h-[320px]">
        <div class="bg-slate-50 px-6 py-3 border-b border-slate-200 flex justify-between items-center">
          <h3 class="font-bold text-slate-800">執行步驟紀錄</h3>
          <span class="text-xs font-mono text-slate-500">
            第 {{ i + 1 }} 輪 | 掃描進度: {{ Math.max(j - i - 1, 0) }} / {{ Math.max(array.length - i - 1, 0) }}
          </span>
        </div>
        <div ref="logContainer" class="flex-1 p-4 overflow-y-auto space-y-3 font-mono text-sm custom-scrollbar">
          <div v-if="logs.length === 0" class="h-full flex items-center justify-center text-slate-400 italic">
            點擊「開始模擬」查看演算法執行步驟...
          </div>
          <div
            v-else
            v-for="log in logs"
            :key="log.id"
            :class="['p-3 rounded-lg border-l-4 shadow-sm', getLogStyle(log.type)]"
          >
            {{ log.message }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.list-move,
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
