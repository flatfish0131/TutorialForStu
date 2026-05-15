<script setup>
import { ref, watch, nextTick, onUnmounted, computed } from 'vue'

const props = defineProps({
  isDescending: {
    type: Boolean,
    default: false
  }
})

// 原始資料，用來處理重新開始
const originalArray = ref([64, 34, 25, 12, 22, 11, 90])
// 實際在變動的陣列
const array = ref([...originalArray.value])

// 為了讓 Vue TransitionGroup 能正確追蹤元素移動，我們需要給每個元素獨一無二的 ID
const arrayIds = ref(array.value.map((_, index) => index))

const inputValue = ref(originalArray.value.join(', '))

// 演算法狀態
const i = ref(0) // 已經排好的元素數量 (從尾巴算起)
const j = ref(0) // 目前正在比較的索引

// idle: 尚未開始, running: 執行中, finished: 排序完成
const status = ref('idle')
// compare: 比較中, swap: 需要交換, next: 前進到下一對
const phase = ref('compare')
const logs = ref([])
const isPlaying = ref(false)
const logContainer = ref(null)
let playInterval = null

// 計算屬性：包裝 array 和 arrayIds 供模板使用
const arrayObj = computed(() => {
  return array.value.map((val, index) => ({
    value: val,
    index: index,
    id: arrayIds.value[index]
  }))
})

// 產生隨機陣列
const generateRandomArray = () => {
  const length = Math.floor(Math.random() * 5) + 6 // 6 到 10 個元素
  const newArr = Array.from({ length }, () => Math.floor(Math.random() * 80) + 10)
  originalArray.value = [...newArr]
  inputValue.value = newArr.join(', ')
  resetSimulation(newArr)
}

// 處理使用者手動輸入陣列
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

// 重置模擬器
const resetSimulation = (currentArray = originalArray.value) => {
  array.value = [...currentArray]
  arrayIds.value = array.value.map((_, index) => Date.now() + index) // 給予新 ID
  i.value = 0
  j.value = 0
  status.value = 'idle'
  phase.value = 'compare'
  logs.value = []
  isPlaying.value = false
}

// 加入新的日誌
const addLog = (message, type = 'normal') => {
  logs.value.push({ id: Date.now() + Math.random(), message, type })
}

// 自動滾動到最新日誌
watch(logs, async () => {
  await nextTick()
  if (logContainer.value) {
    logContainer.value.scrollTop = logContainer.value.scrollHeight
  }
}, { deep: true })

// 交換陣列元素的邏輯
const swapElements = (idx1, idx2) => {
  const tempVal = array.value[idx1]
  array.value[idx1] = array.value[idx2]
  array.value[idx2] = tempVal

  const tempId = arrayIds.value[idx1]
  arrayIds.value[idx1] = arrayIds.value[idx2]
  arrayIds.value[idx2] = tempId
}

// 執行一步氣泡排序邏輯
const nextStep = () => {
  if (status.value === 'finished') return

  if (status.value === 'idle') {
    status.value = 'running'
    const goalText = props.isDescending ? '將較小的數字慢慢推到右邊 (由大到小排序)' : '將較大的數字慢慢推到右邊 (由小到大排序)'
    addLog(`開始氣泡排序！目標是${goalText}。`, 'info')
  }

  if (i.value >= array.value.length - 1) {
    status.value = 'finished'
    isPlaying.value = false
    addLog(`🎉 排序完成！所有的元素皆已到位。`, 'success')
    return
  }

  if (phase.value === 'compare') {
    const val1 = array.value[j.value]
    const val2 = array.value[j.value + 1]
    
    const shouldSwap = props.isDescending ? (val1 < val2) : (val1 > val2)
    const opText = props.isDescending ? '<' : '>'
    const notOpText = props.isDescending ? '>=' : '<='

    if (shouldSwap) {
      phase.value = 'swap'
      addLog(`比較索引 ${j.value} (${val1}) 和索引 ${j.value + 1} (${val2})：發現 ${val1} ${opText} ${val2}，準備交換位置。`, 'warning')
    } else {
      phase.value = 'next'
      addLog(`比較索引 ${j.value} (${val1}) 和索引 ${j.value + 1} (${val2})：${val1} ${notOpText} ${val2}，不需要交換。`, 'normal')
    }
  }
  else if (phase.value === 'swap') {
    const val1 = array.value[j.value]
    const val2 = array.value[j.value + 1]
    swapElements(j.value, j.value + 1)
    phase.value = 'next'
    addLog(`已完成交換：${val1} 和 ${val2} 互換位置。`, 'error') // 用紅色凸顯交換動作
  }
  else if (phase.value === 'next') {
    j.value++

    // 如果 J 已經推到底部（也就是到達已經排好序的邊界）
    if (j.value >= array.value.length - 1 - i.value) {
      const sortedVal = array.value[array.value.length - 1 - i.value]
      const extText = props.isDescending ? '最小值' : '最大值'
      addLog(`這輪結束，目前${extText} ${sortedVal} 已經如氣泡般浮到正確位置！`, 'success')

      j.value = 0
      i.value++

      if (i.value >= array.value.length - 1) {
        status.value = 'finished'
        isPlaying.value = false
        addLog(`🎉 排序完成！所有的元素皆已到位。`, 'success')
      } else {
        phase.value = 'compare'
        addLog(`--- 開始第 ${i.value + 1} 輪比較 ---`, 'info')
      }
    } else {
      phase.value = 'compare'
    }
  }
}

const togglePlay = () => {
  isPlaying.value = !isPlaying.value
}

// 自動播放邏輯
watch(() => [isPlaying.value, status.value], () => {
  clearInterval(playInterval)
  if (isPlaying.value && status.value !== 'finished') {
    playInterval = setInterval(() => {
      nextStep()
    }, 800) // 氣泡排序步驟較多，間隔稍微調快一點 (0.8s)
  }
})

onUnmounted(() => {
  clearInterval(playInterval)
})

// 取得方塊的樣式
const getBoxStyle = (index) => {
  if (status.value === 'finished') {
    return "bg-green-100 border-green-500 text-green-800 shadow-md"
  }

  // 已經排好序的區塊 (右側)
  if (index >= array.value.length - i.value) {
    return "bg-green-100 border-green-500 text-green-800 opacity-90"
  }

  // 正在進行比較的兩個元素
  if (index === j.value || index === j.value + 1) {
    if (phase.value === 'swap') {
      return "bg-red-200 border-red-500 text-red-900 scale-110 shadow-lg z-10"
    }
    return "bg-yellow-200 border-yellow-400 text-yellow-900 scale-105 shadow-md z-10"
  }

  // 其他尚未排序的元素
  return "bg-blue-50 border-blue-300 text-blue-900"
}

// 取得日誌樣式
const getLogStyle = (type) => {
  switch (type) {
    case 'info': return 'bg-blue-50 border-blue-500 text-blue-800 font-bold'
    case 'success': return 'bg-green-50 border-green-500 text-green-800'
    case 'error': return 'bg-red-50 border-red-400 text-red-800' // 交換
    case 'warning': return 'bg-orange-50 border-orange-400 text-orange-800' // 準備交換
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
              <!-- Shuffle Icon -->
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

          <!-- 指標箭頭 (當前比較的元素) -->
          <div class="absolute -top-10 flex flex-col items-center justify-end h-8 w-full">
            <span v-if="(item.index === j || item.index === j + 1) && status !== 'finished' && status !== 'idle'"
                  class="text-orange-500 animate-bounce">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="none"><path d="M12 20l-8-8h16l-8 8z"/></svg>
            </span>
          </div>

          <!-- 陣列元素方塊 (利用高度顯示大小) -->
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

      <!-- 狀態提示字眼 -->
      <div class="mt-10 h-8 flex items-center justify-center">
        <div v-if="status === 'finished'" class="flex items-center gap-2 text-green-600 font-bold text-lg animate-pulse">
          <!-- CheckCircle2 Icon -->
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
          <!-- StepForward Icon -->
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="6" y1="4" x2="6" y2="20"/><polygon points="10,4 20,12 10,20"/></svg>
          {{ status === 'idle' ? '開始模擬' : '下一步 (Next Step)' }}
        </button>

        <div class="flex gap-4">
          <button
            @click="togglePlay"
            :disabled="status === 'finished'"
            :class="['flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-medium transition-colors', isPlaying ? 'bg-amber-100 text-amber-700 hover:bg-amber-200' : 'bg-slate-100 text-slate-700 hover:bg-slate-200 disabled:opacity-50']"
          >
            <!-- Pause Icon -->
            <svg v-if="isPlaying" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
            <!-- Play Icon -->
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="5 3 19 12 5 21 5 3"/></svg>
            {{ isPlaying ? '暫停' : '自動播放' }}
          </button>

          <button
            @click="resetSimulation(originalArray)"
            class="flex-1 flex items-center justify-center gap-2 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-medium transition-colors"
          >
            <!-- RotateCcw Icon -->
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
            重新開始
          </button>
        </div>

        <!-- 圖例 -->
        <div class="mt-4 flex flex-col gap-2 text-sm text-slate-600 border-t pt-4">
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-yellow-200 border-2 border-yellow-400"></span> 正在比較</div>
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-red-200 border-2 border-red-500"></span> 需要交換</div>
          <div class="flex items-center gap-2"><span class="w-4 h-4 rounded bg-green-200 border-2 border-green-500"></span> 已排序完成</div>
        </div>
      </div>

      <!-- 執行紀錄 (Logs) -->
      <div class="md:col-span-2 bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden flex flex-col h-[320px]">
        <div class="bg-slate-50 px-6 py-3 border-b border-slate-200 flex justify-between items-center">
          <h3 class="font-bold text-slate-800">執行步驟紀錄</h3>
          <span class="text-xs font-mono text-slate-500">
            第 {{ i + 1 }} 輪 | 比較進度: {{ j }} / {{ array.length - i - 1 }}
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
/* 陣列元素動畫過渡 */
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
