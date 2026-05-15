<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import Week3 from './components/Week3.vue'
import Week5 from './components/Week5.vue'
import MidtermExam from './components/MidtermExam.vue'
import Week11 from './components/Week11.vue'
import ExamCheer from './components/ExamCheer.vue'

const activeWeek = ref('midterm')

const normalWeeks = [
  { id: 'week3', name: 'Week 3' },
  { id: 'week5', name: 'Week 5' },
  { id: 'midterm', name: '期中考' },
  { id: 'week11', name: 'Week 11' }
]

const isExamTime = ref(false)
let lastExamState = null

const checkTime = () => {
  const now = new Date()
  const M = now.getMonth() + 1
  const D = now.getDate()
  const H = now.getHours()
  const m = now.getMinutes()
  
  const isTargetDate = (M === 4 && D === 17)
  const minutesOfDay = H * 60 + m
  const startMinutes = 15 * 60  // 15:00
  const endMinutes = 17 * 60 + 20 // 17:20
  
  const currentIsExam = (isTargetDate && minutesOfDay >= startMinutes && minutesOfDay < endMinutes)
  
  // 如果不是第一次檢查，且狀態發生切換，就強制刷新網頁
  if (lastExamState !== null && lastExamState !== currentIsExam) {
    window.location.reload()
    return
  }
  
  lastExamState = currentIsExam
  isExamTime.value = currentIsExam
  
  if (currentIsExam) {
    activeWeek.value = 'exam'
  } else {
    if (activeWeek.value === 'exam') {
      activeWeek.value = 'week11'
    }
  }
}

let timer
onMounted(() => {
  checkTime()
  timer = setInterval(checkTime, 1000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

const weeks = computed(() => {
  return isExamTime.value 
    ? [{ id: 'exam', name: '考試加油' }] 
    : normalWeeks
})
</script>

<template>
  <div class="flex h-screen bg-[#F8FAFC] font-sans text-slate-800 antialiased overflow-hidden">
    
    <!-- Sidebar - Fixed Full Height -->
    <aside v-if="activeWeek !== 'exam'" class="w-64 bg-white border-r border-slate-200/60 flex flex-col shadow-[4px_0_24px_rgba(0,0,0,0.02)] z-20 shrink-0 h-full">
      <div class="p-8 pb-6 border-b border-slate-50">
        <div class="flex items-center gap-3">
          <div class="text-2xl">🎓</div>
          <h1 class="text-lg font-extrabold text-slate-900 tracking-tight leading-tight">
            資電一甲<br/><span class="text-blue-600">微處理機實習</span>
          </h1>
        </div>
      </div>
      
      <nav class="flex-1 px-4 py-8 space-y-1.5 overflow-y-auto">
        <div class="px-4 mb-4">
          <p class="text-[10px] font-bold text-slate-400 uppercase tracking-[0.2em]">學習單元</p>
        </div>
        <button
          v-for="week in weeks"
          :key="week.id"
          @click="activeWeek = week.id"
          :class="[
            activeWeek === week.id
              ? 'bg-blue-50/50 text-blue-700 font-bold'
              : 'text-slate-500 hover:bg-slate-50 hover:text-slate-900',
            'w-full flex items-center px-4 py-3.5 rounded-xl transition-all duration-200 text-left cursor-pointer group relative'
          ]"
        >
          <div 
            v-if="activeWeek === week.id" 
            class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"
          ></div>
          <span class="text-xs uppercase tracking-[0.15em] ml-2">{{ week.name }}</span>
          <svg 
            v-if="activeWeek === week.id"
            xmlns="http://www.w3.org/2000/svg" 
            class="h-4 w-4 ml-auto text-blue-400" 
            fill="none" viewBox="0 0 24 24" stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </nav>

      <!-- Footer at Bottom -->
      <div class="p-6 mt-auto border-t border-slate-50">
        <div class="bg-slate-50/80 rounded-2xl p-4 border border-slate-100 flex flex-col items-center gap-2">
          <div class="w-8 h-8 bg-white rounded-full flex items-center justify-center shadow-sm">
            <span class="text-xs">🏫</span>
          </div>
          <p class="text-[10px] font-bold text-slate-400 tracking-wider uppercase">© 2026 FCU SE Lab</p>
        </div>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 overflow-y-auto relative min-w-0 bg-[#F8FAFC]">
      <div class="p-10 w-full max-w-[1600px] mx-auto min-h-screen flex flex-col">
        
        <!-- Header -->
        <header v-if="activeWeek !== 'exam'" class="mb-10 border-b border-slate-200/50 pb-8 shrink-0">
          <div>
            <h2 class="text-4xl font-black text-slate-900 tracking-tight">
              {{ weeks.find(w => w.id === activeWeek)?.name }}
            </h2>
          </div>
        </header>

        <!-- Content Area -->
        <div class="flex-1">
          <Transition
            mode="out-in"
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="opacity-0 translate-y-4"
            enter-to-class="opacity-100 translate-y-0"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="opacity-100 translate-y-0"
            leave-to-class="opacity-0 translate-y-4"
          >
            <div :key="activeWeek">
              <ExamCheer v-if="activeWeek === 'exam'" />
              <Week3 v-if="activeWeek === 'week3'" />
              <Week5 v-if="activeWeek === 'week5'" />
              <MidtermExam v-if="activeWeek === 'midterm'" />
              <Week11 v-if="activeWeek === 'week11'" />
            </div>
          </Transition>
        </div>

      </div>
    </main>

  </div>
</template>

<style>
/* 全域樣式已在 main.css 中處理，這裡可以放一些 App 特有的 */
</style>
