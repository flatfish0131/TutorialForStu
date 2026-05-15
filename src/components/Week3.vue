<script setup>
import { ref } from 'vue'
import BinarySearchSimulator from './BinarySearchSimulator.vue'
import BubbleSortSimulator from './BubbleSortSimulator.vue'
import HomeworkSolution from './HomeworkSolution.vue'

const activeTab = ref('binary-search')

const tabs = [
  { id: 'binary-search', name: '二元搜尋 (Binary Search)' },
  { id: 'bubble-sort', name: '氣泡排序 (Bubble Sort)' },
  { id: 'homework', name: '上週作業解答 (HW)' }
]
</script>

<template>
  <div class="space-y-6">
    <!-- Tab 切換器 -->
    <div class="flex justify-center border-b border-slate-200">
      <nav class="flex space-x-8" aria-label="Tabs">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          @click="activeTab = tab.id"
          :class="[
            activeTab === tab.id
              ? 'border-blue-500 text-blue-600'
              : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300',
            'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-lg transition-all cursor-pointer'
          ]"
        >
          {{ tab.name }}
        </button>
      </nav>
    </div>

    <!-- 內容區塊 -->
    <div class="mt-6">
      <Transition
        mode="out-in"
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="opacity-0 translate-y-4"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 translate-y-4"
      >
        <div :key="activeTab">
          <BinarySearchSimulator v-if="activeTab === 'binary-search'" />
          <BubbleSortSimulator v-if="activeTab === 'bubble-sort'" />
          <HomeworkSolution v-if="activeTab === 'homework'" />
        </div>
      </Transition>
    </div>
  </div>
</template>
