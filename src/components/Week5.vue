<script setup>
import { ref, computed } from 'vue'
import SelectionSortSimulator from './SelectionSortSimulator.vue'

const activeSubTab = ref('pointer')

const subTabs = [
  { id: 'pointer', name: '指標教學' },
  { id: 'selection-sort', name: 'Selection Sort 教學' }
]

const pointerTab = ref('value-address')
const pointerSubTabs = [
  { id: 'value-address', name: '值與址調用' },
  { id: 'arithmetic', name: '指標算術' },
  { id: 'reference', name: 'Call by Reference' },
  { id: 'traversal', name: '陣列拜訪' },
  { id: 'rotation', name: '陣列循環位移' }
]

// Value and Address State
const demoVar = ref(10)
const demoVarAddress = '0x7FFD0004'
const demoPtr = ref('0x7FFD0004')
const demoPtrAddress = '0x7FFD0000'

// Pointer Arithmetic State
const array = ref([10, 20, 30, 40, 50])
const ptrIndex = ref(0)
const baseAddress = 0x7ffd0000

const currentAddress = computed(() => {
  return '0x' + (baseAddress + ptrIndex.value * 4).toString(16).toUpperCase()
})

const movePtr = (delta) => {
  const newIndex = ptrIndex.value + delta
  if (newIndex >= 0 && newIndex < array.value.length) {
    ptrIndex.value = newIndex
  }
}

// Call by Reference State
const varA = ref(10)
const varB = ref(20)
const isSwapping = ref(false)

const startSwap = () => {
  isSwapping.value = true
  setTimeout(() => {
    const temp = varA.value
    varA.value = varB.value
    varB.value = temp
    isSwapping.value = false
  }, 1000)
}

// Array Traversal State
const traversalIndex = ref(-1)
const isAutoTraversing = ref(false)

const startTraversal = () => {
  if (isAutoTraversing.value) return
  isAutoTraversing.value = true
  traversalIndex.value = 0
  const interval = setInterval(() => {
    if (traversalIndex.value < array.value.length - 1) {
      traversalIndex.value++
    } else {
      clearInterval(interval)
      isAutoTraversing.value = false
      setTimeout(() => { traversalIndex.value = -1 }, 1000)
    }
  }, 800)
}

// Array Rotation State
const rotationArray = ref([10, 20, 30, 40, 50])
const lastElementBuffer = ref(null)
const rotationStep = ref(0) 
const shiftIndex = ref(-1)
const totalK = ref(1)
const currentK = ref(0)
const rotateStatus = ref('Ready')

const resetRotation = () => {
  rotationArray.value = [10, 20, 30, 40, 50]
  lastElementBuffer.value = null
  rotationStep.value = 0
  shiftIndex.value = -1
  currentK.value = 0
  rotateStatus.value = 'Ready'
}

const stepRotation = () => {
  const size = rotationArray.value.length
  if (rotationStep.value === 0 || rotationStep.value === 4) {
    if (currentK.value >= totalK.value && rotationStep.value === 4) {
       rotateStatus.value = 'All Rotations Finished'
       return
    }
    rotationStep.value = 1
    rotateStatus.value = 'Step 1: Save last element'
    lastElementBuffer.value = rotationArray.value[size - 1]
    return
  }
  if (rotationStep.value === 1) {
    rotationStep.value = 2
    shiftIndex.value = size - 1
    rotateStatus.value = `Step 2: Shifting elements right (i=${shiftIndex.value})`
    return
  }
  if (rotationStep.value === 2) {
    if (shiftIndex.value > 0) {
      rotationArray.value[shiftIndex.value] = rotationArray.value[shiftIndex.value - 1]
      shiftIndex.value--
      rotateStatus.value = `Shifting... (i=${shiftIndex.value})`
      if (shiftIndex.value === 0) {
        rotationStep.value = 3
        rotateStatus.value = 'Step 3: Place stored element at start'
      }
    }
    return
  }
  if (rotationStep.value === 3) {
    rotationArray.value[0] = lastElementBuffer.value
    lastElementBuffer.value = null
    rotationStep.value = 4
    currentK.value++
    rotateStatus.value = `Rotation ${currentK.value} Complete`
    return
  }
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

    <!-- 指標教學 Tab Content -->
    <div v-if="activeSubTab === 'pointer'" class="space-y-8 animate-in">
      <!-- Pointer Sub-tabs -->
      <div class="flex flex-wrap gap-2 p-1 bg-slate-100 rounded-2xl w-fit mx-auto">
        <button 
          v-for="sub in pointerSubTabs" 
          :key="sub.id"
          @click="pointerTab = sub.id"
          :class="[
            'px-6 py-2 rounded-xl text-sm font-bold transition-all cursor-pointer',
            pointerTab === sub.id ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-500 hover:text-slate-700'
          ]"
        >
          {{ sub.name }}
        </button>
      </div>

      <!-- Value and Address -->
      <div v-if="pointerTab === 'value-address'" class="grid grid-cols-1 lg:grid-cols-2 gap-8 animate-in">
        <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100 flex flex-col">
            <h3 class="text-xl font-bold mb-6 flex items-center gap-2">
              <span class="w-8 h-8 bg-indigo-100 text-indigo-600 rounded-lg flex items-center justify-center text-sm">1</span>
              值與位址記憶體模型
            </h3>
            <div class="flex justify-around items-center gap-2 py-8 w-full max-w-sm mx-auto">
              <!-- Pointer Memory Block -->
              <div class="flex flex-col items-center">
                <span class="text-xs font-mono text-slate-400 mb-2">{{ demoPtrAddress }}</span>
                <div class="w-24 h-24 rounded-2xl border-2 border-indigo-200 bg-indigo-50 flex flex-col items-center justify-center shadow-sm relative">
                  <span class="text-[10px] absolute top-2 text-indigo-400 font-bold">指標 p</span>
                  <span class="text-xs font-mono font-bold text-indigo-700">{{ demoPtr }}</span>
                </div>
              </div>

              <!-- Arrow pointing from pointer to variable -->
              <div class="flex-1 flex items-center justify-center relative">
                  <div class="w-full h-[2px] bg-indigo-300"></div>
                  <!-- Arrow tip -->
                  <div class="absolute right-0 w-3 h-3 border-t-2 border-r-2 border-indigo-300 rotate-45 transform translate-x-[1px]"></div>
              </div>

              <!-- Variable Memory Block -->
              <div class="flex flex-col items-center">
                <span class="text-xs font-mono text-slate-400 mb-2">{{ demoVarAddress }}</span>
                <div class="w-24 h-24 rounded-2xl border-2 border-pink-200 bg-pink-50 flex flex-col items-center justify-center shadow-sm relative">
                  <span class="text-[10px] absolute top-2 text-pink-400 font-bold">變數 a</span>
                  <span class="text-2xl font-mono font-bold text-pink-700 transition-all duration-300">{{ demoVar }}</span>
                </div>
              </div>
            </div>
            
            <div class="mt-4 bg-slate-50 p-6 rounded-2xl border border-slate-100 text-sm space-y-3">
              <div class="flex justify-between items-center border-b border-slate-200 pb-2">
                 <span class="font-mono text-slate-500">a (值)</span>
                 <span class="font-mono font-bold text-pink-600 transition-all duration-300">{{ demoVar }}</span>
              </div>
              <div class="flex justify-between items-center border-b border-slate-200 pb-2">
                 <span class="font-mono text-slate-500">&amp;a (址)</span>
                 <span class="font-mono font-bold text-slate-700">{{ demoVarAddress }}</span>
              </div>
              <div class="flex justify-between items-center border-b border-slate-200 pb-2">
                 <span class="font-mono text-slate-500">p (值)</span>
                 <span class="font-mono font-bold text-indigo-600">{{ demoPtr }}</span>
              </div>
              <div class="flex justify-between items-center border-b border-slate-200 pb-2">
                 <span class="font-mono text-slate-500">*p (解參照取得的值)</span>
                 <span class="font-mono font-bold text-pink-600 transition-all duration-300">{{ demoVar }}</span>
              </div>
              <div class="flex justify-between items-center">
                 <span class="font-mono text-slate-500">&amp;p (指標本身位址)</span>
                 <span class="font-mono font-bold text-slate-700">{{ demoPtrAddress }}</span>
              </div>
            </div>
        </div>

        <div class="space-y-6">
          <div class="bg-slate-900 p-8 rounded-3xl shadow-sm border border-slate-700 font-mono text-sm leading-relaxed text-blue-300 relative overflow-hidden group">
             <div class="absolute inset-0 bg-gradient-to-br from-indigo-500/10 to-pink-500/10 opacity-0 group-hover:opacity-100 transition-opacity"></div>
             <p><span class="text-pink-400">int</span> a = <span class="text-yellow-400 transition-all duration-300">{{ demoVar }}</span>;</p>
             <p><span class="text-pink-400">int</span> *p = &amp;a;</p>
             <div class="h-px w-full bg-slate-700 my-4"></div>
             <p><span class="text-slate-500">// 1. 直接透過變數名稱存取與修改</span></p>
             <p>a = <span class="text-yellow-400">88</span>;</p>
             <p>printf(<span class="text-green-400">"%d\n"</span>, a); <span class="text-slate-500">// 輸出：88</span></p>
             <div class="h-px w-full bg-slate-700 my-4"></div>
             <p><span class="text-slate-500">// 2. 透過指標解參照(Dereference)存取與修改</span></p>
             <p>*p = <span class="text-yellow-400">99</span>;</p>
             <p>printf(<span class="text-green-400">"%d\n"</span>, *p); <span class="text-slate-500">// 輸出：99</span></p>
          </div>
          
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
             <h3 class="text-lg font-bold mb-4 text-slate-700">動態執行展示</h3>
             <div class="space-y-4">
                 <div>
                    <label class="block text-xs font-bold text-slate-500 mb-2 uppercase tracking-wide">直接修改 a 的值</label>
                    <div class="flex gap-2">
                       <button @click="demoVar = Math.floor(Math.random() * 100)" class="flex-1 bg-pink-50 hover:bg-pink-100 border-2 border-pink-100 hover:border-pink-300 text-pink-700 font-bold py-3 rounded-xl transition-all text-sm shadow-sm active:scale-95 cursor-pointer">執行 a = 隨機</button>
                       <button @click="demoVar = 88" class="flex-1 bg-pink-50 hover:bg-pink-100 border-2 border-pink-100 hover:border-pink-300 text-pink-700 font-bold py-3 rounded-xl transition-all text-sm shadow-sm active:scale-95 cursor-pointer">執行 a = 88</button>
                    </div>
                 </div>
                 <div>
                    <label class="block text-xs font-bold text-slate-500 mb-2 uppercase tracking-wide mt-6">透過指標 *p 修改值</label>
                    <div class="flex gap-2">
                       <button @click="demoVar += 10" class="flex-1 bg-indigo-50 hover:bg-indigo-100 border-2 border-indigo-100 hover:border-indigo-300 text-indigo-700 font-bold py-3 rounded-xl transition-all text-sm shadow-sm active:scale-95 cursor-pointer">執行 *p += 10</button>
                       <button @click="demoVar = 99" class="flex-1 bg-indigo-50 hover:bg-indigo-100 border-2 border-indigo-100 hover:border-indigo-300 text-indigo-700 font-bold py-3 rounded-xl transition-all text-sm shadow-sm active:scale-95 cursor-pointer">執行 *p = 99</button>
                    </div>
                 </div>
             </div>
          </div>
        </div>
      </div>

      <!-- Pointer Arithmetic -->
      <div v-if="pointerTab === 'arithmetic'" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-2 space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-xl font-bold mb-6 flex items-center gap-2">
              <span class="w-8 h-8 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center text-sm">1</span>
              指標算術動態模擬
            </h3>
            
            <div class="relative flex justify-center items-end h-40 gap-4 mb-12">
              <div 
                v-for="(val, idx) in array" 
                :key="idx"
                :class="[
                  'w-20 h-20 rounded-2xl flex flex-col items-center justify-center transition-all duration-500 border-2 relative',
                  ptrIndex === idx 
                    ? 'border-blue-500 bg-blue-50/30 scale-110 shadow-lg shadow-blue-100' 
                    : 'border-slate-100 bg-slate-50 text-slate-400'
                ]"
              >
                <span class="text-xs absolute -top-8 font-mono text-slate-400">
                  0x{{ (baseAddress + idx * 4).toString(16).toUpperCase() }}
                </span>
                <span :class="['text-xl font-mono font-bold', ptrIndex === idx ? 'text-blue-600' : 'text-slate-400']">
                  {{ val }}
                </span>
                <span class="text-[10px] mt-1 font-bold">arr[{{ idx }}]</span>
                
                <div v-if="ptrIndex === idx" class="absolute -bottom-10 flex flex-col items-center animate-bounce">
                  <div class="w-0.5 h-6 bg-blue-600"></div>
                  <div class="text-[10px] font-black text-blue-600 uppercase tracking-tighter">ptr</div>
                </div>
              </div>
            </div>

            <div class="bg-slate-900 rounded-2xl p-6 font-mono text-sm text-blue-400 shadow-inner leading-relaxed">
              <p><span class="text-slate-500">// 目前指標指向的位址</span></p>
              <p>ptr = <span class="text-yellow-400">{{ currentAddress }}</span>;</p>
              <p><span class="text-slate-500">// 取得指標指向的值</span></p>
              <p>printf(<span class="text-green-400">"%d"</span>, *ptr); <span class="text-slate-500">// 輸出：{{ array[ptrIndex] }}</span></p>
            </div>
          </div>
        </div>

        <div class="space-y-6">
          <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
            <h3 class="text-lg font-bold mb-4">控制台</h3>
            <div class="grid grid-cols-2 gap-3">
              <button @click="movePtr(-1)" :disabled="ptrIndex === 0" class="flex flex-col items-center gap-2 p-4 rounded-2xl border border-slate-200 hover:border-blue-200 hover:bg-blue-50 transition-all cursor-pointer disabled:opacity-30 group">
                <span class="text-xl group-hover:-translate-x-1 transition-transform">⬅️</span>
                <span class="text-xs font-bold uppercase tracking-widest">ptr--</span>
              </button>
              <button @click="movePtr(1)" :disabled="ptrIndex === array.length - 1" class="flex flex-col items-center gap-2 p-4 rounded-2xl border border-slate-200 hover:border-blue-200 hover:bg-blue-50 transition-all cursor-pointer disabled:opacity-30 group">
                <span class="text-xl group-hover:translate-x-1 transition-transform">➡️</span>
                <span class="text-xs font-bold uppercase tracking-widest">ptr++</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Call by Reference -->
      <div v-if="pointerTab === 'reference'" class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100 animate-in">
         <div class="max-w-4xl mx-auto space-y-12 py-8 text-center">
           <h3 class="text-2xl font-black text-slate-800">Call by Reference (變數交換)</h3>
           
           <div class="flex justify-around items-center gap-8 relative py-12">
             <div class="flex flex-col items-center gap-4 transition-all duration-700" :class="{ 'translate-x-20 scale-90 opacity-50': isSwapping }">
               <div class="w-24 h-24 bg-indigo-600 rounded-3xl flex items-center justify-center text-white text-3xl font-black shadow-xl">{{ varA }}</div>
               <div class="px-3 py-1 bg-indigo-50 text-indigo-600 rounded-full text-xs font-bold">int a</div>
             </div>
             <div class="w-16 h-16 rounded-full border-4 border-slate-100 flex items-center justify-center shadow-sm">
               <span class="text-2xl" :class="{ 'animate-spin': isSwapping }">🔄</span>
             </div>
             <div class="flex flex-col items-center gap-4 transition-all duration-700" :class="{ '-translate-x-20 scale-90 opacity-50': isSwapping }">
                <div class="w-24 h-24 bg-pink-600 rounded-3xl flex items-center justify-center text-white text-3xl font-black shadow-xl">{{ varB }}</div>
                <div class="px-3 py-1 bg-pink-50 text-pink-600 rounded-full text-xs font-bold">int b</div>
             </div>
           </div>

           <div class="grid grid-cols-1 md:grid-cols-2 gap-8 text-left">
             <div class="bg-slate-900 rounded-3xl p-6 font-mono text-xs shadow-2xl">
               <p class="text-pink-400">void <span class="text-blue-400">swap</span>(int *n1, int *n2) {</p>
               <p class="ml-4 text-white">  int temp = *n1;</p>
               <p class="ml-4 text-white">  *n1 = *n2;</p>
               <p class="ml-4 text-white">  *n2 = temp;</p>
               <p class="text-pink-400">}</p>
             </div>
             <div class="flex flex-col justify-center gap-6">
               <p class="text-slate-600 text-sm">
                 透過指標傳遞位址，函式可以直接修改主程式中的原始變數資訊。
               </p>
               <button @click="startSwap" :disabled="isSwapping" class="bg-blue-600 hover:bg-blue-700 disabled:bg-slate-300 text-white font-bold py-4 rounded-2xl shadow-lg transition-all cursor-pointer">執行 swap(&a, &b)</button>
             </div>
           </div>
         </div>
      </div>

      <!-- Traversal -->
      <div v-if="pointerTab === 'traversal'" class="bg-white p-10 rounded-3xl shadow-sm border border-slate-100 flex flex-col items-center animate-in">
        <h3 class="text-2xl font-black mb-8">陣列指標步進 (Traversal)</h3>
        <div class="flex flex-wrap justify-center gap-4 mb-12">
          <div v-for="(val, idx) in array" :key="idx" :class="['w-24 h-24 rounded-3xl border-2 flex flex-col items-center justify-center transition-all duration-500', traversalIndex === idx ? 'border-blue-500 bg-blue-600 text-white shadow-xl -translate-y-2' : 'border-slate-100 bg-slate-50 text-slate-300 scale-95']">
            <span class="text-xs opacity-50 mb-1">*(ptr + {{ idx }})</span>
            <span class="text-2xl font-mono">{{ val }}</span>
          </div>
        </div>
        <button @click="startTraversal" :disabled="isAutoTraversing" class="bg-slate-900 text-white px-10 py-4 rounded-2xl font-black uppercase tracking-widest hover:bg-black transition-all cursor-pointer disabled:opacity-50">開始逐一走訪</button>
      </div>

      <!-- Rotation -->
      <div v-if="pointerTab === 'rotation'" class="grid grid-cols-1 xl:grid-cols-2 gap-10 animate-in">
        <div class="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
          <div class="flex justify-between items-center mb-12">
            <h3 class="text-xl font-bold">循環位移模擬</h3>
            <button @click="resetRotation" class="p-2 text-slate-400 hover:text-slate-600 transition-colors cursor-pointer">🔄</button>
          </div>
          <div class="space-y-12">
            <div class="flex flex-col items-center">
               <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2">lastElement Buffer</p>
               <div :class="['w-16 h-16 rounded-2xl flex items-center justify-center font-mono font-bold text-xl border-2 transition-all duration-500', lastElementBuffer !== null ? 'border-orange-500 bg-orange-50 text-orange-600 shadow-xl scale-110' : 'border-slate-50 bg-slate-50 text-slate-200 border-dashed']">
                 {{ lastElementBuffer ?? '?' }}
               </div>
            </div>
            <div class="flex gap-3 justify-center">
              <div v-for="(val, idx) in rotationArray" :key="idx" :class="['w-16 h-16 rounded-2xl flex flex-col items-center justify-center font-mono font-bold border-2 transition-all duration-300 relative', rotationStep === 2 && (shiftIndex === idx || shiftIndex === idx + 1) ? 'border-blue-500 bg-blue-50 text-blue-700' : rotationStep === 3 && idx === 0 ? 'border-green-500 bg-green-50 text-green-700' : 'border-slate-100 bg-white text-slate-400']">
                <span class="text-lg">{{ val }}</span>
                <span class="text-[8px] absolute -bottom-6 text-slate-400">arr[{{ idx }}]</span>
                <div v-if="rotationStep === 2 && shiftIndex === idx" class="absolute -top-6 text-blue-500 animate-pulse text-xs">⬅️ shift</div>
              </div>
            </div>
          </div>
          <p class="mt-16 text-sm text-slate-600 font-mono text-center">{{ rotateStatus }}</p>
          <button @click="stepRotation" class="w-full mt-6 bg-slate-900 text-white py-5 rounded-[2rem] font-bold text-lg cursor-pointer">STEP EXECUTION</button>
        </div>
        <div class="bg-slate-900 rounded-[2.5rem] p-8 font-mono text-xs shadow-2xl text-slate-500">
          <p class="text-indigo-400"><span class="text-pink-400">void</span> rotateRight(int *arr, int size) {</p>
          <p class="pl-4" :class="{ 'text-white bg-blue-500/20 rounded px-1': rotationStep === 1 }">int lastElement = *(arr + size - 1);</p>
          <p class="pl-4" :class="{ 'text-white bg-blue-500/10 rounded px-1': rotationStep === 2 }">for (int i = size - 1; i > 0; i--) {</p>
          <p class="pl-8" :class="{ 'text-blue-300 bg-blue-500/5 rounded px-1': rotationStep === 2 }">*(arr + i) = *(arr + i - 1);</p>
          <p class="pl-4">}</p>
          <p class="pl-4" :class="{ 'text-white bg-green-500/20 rounded px-1': rotationStep === 3 }">*arr = lastElement;</p>
          <p class="text-indigo-400">}</p>
        </div>
      </div>
    </div>

    <!-- Selection Sort Tab Content -->
    <div v-if="activeSubTab === 'selection-sort'" class="animate-in">
      <SelectionSortSimulator />
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
