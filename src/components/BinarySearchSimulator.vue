<script setup>
import { ref, watch, nextTick, onUnmounted } from 'vue'

// 狀態管理
const array = ref([2, 5, 8, 12, 16, 23, 38, 56, 72, 91])
const target = ref(23)
const inputValue = ref("2, 5, 8, 12, 16, 23, 38, 56, 72, 91")

// 演算法狀態
const left = ref(0)
const right = ref(array.value.length - 1)
const mid = ref(null)

// idle: 尚未開始, running: 執行中, found: 找到目標, not_found: 找不到目標
const status = ref('idle')
// calc_mid: 計算中間值, compare: 比較目標值與中間值
const phase = ref('calc_mid')
const logs = ref([])
const isPlaying = ref(false)
const logContainer = ref(null)
const comparisonCount = ref(0)
let playInterval = null

// 產生隨機排序陣列
const generateRandomArray = () => {
  const length = Math.floor(Math.random() * 6) + 8 // 8 到 13 個元素
  const newArr = Array.from({ length }, () => Math.floor(Math.random() * 100))
  newArr.sort((a, b) => a - b)

  // 隨機挑選一個目標值 (有 70% 機率在陣列中，30% 機率不在)
  const isInArray = Math.random() > 0.3
  const newTarget = isInArray
    ? newArr[Math.floor(Math.random() * newArr.length)]
    : Math.floor(Math.random() * 100)

  array.value = newArr
  inputValue.value = newArr.join(', ')
  target.value = newTarget
  resetSimulation(newArr)
}

// 處理使用者手動輸入陣列
const handleArrayInputChange = () => {
  const parsed = inputValue.value
    .split(',')
    .map(s => parseInt(s.trim()))
    .filter(n => !isNaN(n))

  if (parsed.length > 0) {
    const sorted = [...parsed].sort((a, b) => a - b)
    array.value = sorted
    resetSimulation(sorted)
  }
}

const handleTargetChange = () => {
  if (typeof target.value !== 'number') return
  resetSimulation(array.value)
}

// 重置模擬器
const resetSimulation = (currentArray = array.value) => {
  left.value = 0
  right.value = currentArray.length - 1
  mid.value = null
  status.value = 'idle'
  phase.value = 'calc_mid'
  logs.value = []
  comparisonCount.value = 0
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

// 執行一步
const nextStep = () => {
  if (status.value === 'found' || status.value === 'not_found') return

  if (status.value === 'idle') {
    status.value = 'running'
    addLog(`開始二元搜尋，尋找目標值: ${target.value}`, 'info')
  }

  if (phase.value === 'calc_mid') {
    if (left.value > right.value) {
      status.value = 'not_found'
      isPlaying.value = false
      addLog(`Left (${left.value}) > Right (${right.value})，搜尋範圍為空。找不到目標值 ${target.value}！`, 'error')
      return
    }

    const newMid = Math.floor((left.value + right.value) / 2)
    mid.value = newMid
    phase.value = 'compare'
    addLog(`計算中間索引: Mid = floor((${left.value} + ${right.value}) / 2) = ${newMid}。目前中間值為 ${array.value[newMid]}。`, 'normal')
  }
  else if (phase.value === 'compare') {
    comparisonCount.value++
    const midValue = array.value[mid.value]

    if (midValue === target.value) {
      status.value = 'found'
      isPlaying.value = false
      addLog(`🎉 找到目標值！${midValue} 等於 ${target.value}，位於索引 ${mid.value}。`, 'success')
    } else if (midValue < target.value) {
      left.value = mid.value + 1
      mid.value = null
      phase.value = 'calc_mid'
      addLog(`中間值 ${midValue} < 目標值 ${target.value}。目標在右半部，更新 Left = ${left.value}`, 'warning')
    } else {
      right.value = mid.value - 1
      mid.value = null
      phase.value = 'calc_mid'
      addLog(`中間值 ${midValue} > 目標值 ${target.value}。目標在左半部，更新 Right = ${right.value}`, 'warning')
    }
  }
}

const togglePlay = () => {
  isPlaying.value = !isPlaying.value
}

// 自動播放邏輯
watch(() => [isPlaying.value, status.value, phase.value, left.value, right.value], () => {
  clearInterval(playInterval)
  if (isPlaying.value && status.value !== 'found' && status.value !== 'not_found') {
    playInterval = setInterval(() => {
      nextStep()
    }, 1500) // 每 1.5 秒執行一步
  }
})

onUnmounted(() => {
  clearInterval(playInterval)
})

// 取得方塊的樣式
const getBoxStyle = (index) => {
  if (status.value === 'found' && index === mid.value) {
    return "bg-green-500 border-green-600 text-white scale-110 shadow-lg z-10"
  }
  if (index === mid.value) {
    return "bg-yellow-400 border-yellow-500 text-yellow-900 scale-110 shadow-lg z-10"
  }
  if (index < left.value || index > right.value) {
    return "bg-gray-100 border-gray-200 text-gray-400 opacity-60"
  }
  return "bg-blue-50 border-blue-400 text-blue-900 shadow-sm"
}

// 取得日誌樣式
const getLogStyle = (type) => {
  switch (type) {
    case 'info': return 'bg-blue-50 border-blue-500 text-blue-800'
    case 'success': return 'bg-green-50 border-green-500 text-green-800'
    case 'error': return 'bg-red-50 border-red-500 text-red-800'
    case 'warning': return 'bg-orange-50 border-orange-400 text-orange-800'
    default: return 'bg-slate-50 border-slate-400 text-slate-700'
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- 設定面板 -->
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 flex flex-col md:flex-row gap-6 items-center justify-between">
      <div class="flex-1 w-full space-y-4">
        <div>
          <label class="block text-sm font-medium text-slate-700 mb-1">自訂陣列 (必須為遞增排序)</label>
          <input
            type="text"
            v-model="inputValue"
            @input="handleArrayInputChange"
            :disabled="status !== 'idle'"
            class="w-full px-4 py-2 bg-slate-50 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:opacity-50"
            placeholder="例如: 1, 3, 5, 7, 9"
          />
        </div>
        <div class="flex items-center gap-4">
          <div class="flex-1">
            <label class="block text-sm font-medium text-slate-700 mb-1">目標值 (Target)</label>
            <input
              type="number"
              v-model.number="target"
              @input="handleTargetChange"
              :disabled="status !== 'idle'"
              class="w-full px-4 py-2 bg-slate-50 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:opacity-50"
            />
          </div>
          <button
            @click="generateRandomArray"
            :disabled="status !== 'idle'"
            class="mt-6 flex items-center gap-2 px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg transition-colors disabled:opacity-50"
          >
            <!-- Shuffle Icon -->
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 3h5v5M4 20L21 3M21 16v5h-5M15 15l6 6M4 4l5 5"/></svg>
            隨機產生
          </button>
        </div>
      </div>
    </div>

    <!-- 視覺化陣列區塊 -->
    <div class="bg-white p-8 rounded-2xl shadow-sm border border-slate-200 overflow-x-auto min-h-[250px] flex flex-col items-center justify-center">
      <div class="flex gap-2 md:gap-4 items-end relative">
        <div v-for="(num, index) in array" :key="index" class="flex flex-col items-center group">

          <!-- 指標標籤 (L, M, R) -->
          <div class="h-8 mb-2 flex flex-col justify-end gap-1">
            <span v-if="index === left && status !== 'found' && status !== 'not_found'" class="bg-blue-600 text-white text-[10px] font-bold px-1.5 py-0.5 rounded shadow-sm animate-bounce">L</span>
            <span v-if="index === mid && status !== 'found' && status !== 'not_found'" class="bg-yellow-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded shadow-sm animate-bounce" style="animation-delay: 0.1s">M</span>
            <span v-if="index === right && status !== 'found' && status !== 'not_found'" class="bg-purple-600 text-white text-[10px] font-bold px-1.5 py-0.5 rounded shadow-sm animate-bounce" style="animation-delay: 0.2s">R</span>
          </div>

          <!-- 陣列元素方塊 -->
          <div :class="['w-12 h-12 md:w-16 md:h-16 flex items-center justify-center text-lg md:text-xl font-bold border-2 rounded-xl transition-all duration-500', getBoxStyle(index)]">
            {{ num }}
          </div>

          <!-- 陣列索引 -->
          <div class="mt-2 text-xs md:text-sm text-slate-400 font-mono">
            {{ index }}
          </div>
        </div>
      </div>

      <!-- 狀態提示字眼 -->
      <div class="mt-10 h-8 flex items-center justify-center">
        <div v-if="status === 'found'" class="flex items-center gap-2 text-green-600 font-bold text-lg animate-pulse">
          <!-- CheckCircle2 Icon -->
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="M22 4L12 14.01l-3-3"/></svg>
          成功找到目標值 {{ target }}！
        </div>
        <div v-if="status === 'not_found'" class="flex items-center gap-2 text-red-500 font-bold text-lg">
          <!-- XCircle Icon -->
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/></svg>
          陣列中不存在目標值 {{ target }}。
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
          :disabled="status === 'found' || status === 'not_found' || isPlaying"
          class="flex items-center justify-center gap-2 w-full py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-colors disabled:bg-blue-300"
        >
          <!-- StepForward Icon -->
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="6" y1="4" x2="6" y2="20"/><polygon points="10,4 20,12 10,20"/></svg>
          {{ status === 'idle' ? '開始模擬' : '下一步 (Next Step)' }}
        </button>

        <div class="flex gap-4">
          <button
            @click="togglePlay"
            :disabled="status === 'found' || status === 'not_found'"
            :class="['flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-medium transition-colors', isPlaying ? 'bg-amber-100 text-amber-700 hover:bg-amber-200' : 'bg-slate-100 text-slate-700 hover:bg-slate-200 disabled:opacity-50']"
          >
            <!-- Pause Icon -->
            <svg v-if="isPlaying" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
            <!-- Play Icon -->
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="5 3 19 12 5 21 5 3"/></svg>
            {{ isPlaying ? '暫停' : '自動播放' }}
          </button>

          <button
            @click="resetSimulation(array)"
            class="flex-1 flex items-center justify-center gap-2 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-medium transition-colors"
          >
            <!-- RotateCcw Icon -->
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
            重新開始
          </button>
        </div>
      </div>

      <!-- 執行紀錄 (Logs) -->
      <div class="md:col-span-2 bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden flex flex-col h-[280px]">
        <div class="bg-slate-50 px-6 py-3 border-b border-slate-200 flex justify-between items-center">
          <h3 class="font-bold text-slate-800">執行步驟紀錄</h3>
          <span class="text-xs font-mono text-slate-500 flex gap-4">
            <span>Left: {{ left }} | Mid: {{ mid !== null ? mid : '-' }} | Right: {{ right }}</span>
            <span class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded font-bold">搜尋次數: {{ comparisonCount }}</span>
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
