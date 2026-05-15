<script setup>
</script>

<template>
  <div class="min-h-[70vh] flex items-center justify-center bg-gradient-to-br from-indigo-950 via-purple-900 to-slate-900 rounded-3xl p-8 relative overflow-hidden shadow-2xl border border-indigo-500/30 mt-6 group">
    <!-- 裝飾用背景光暈 -->
    <div class="absolute top-0 left-1/4 w-[500px] h-[500px] bg-blue-500/20 rounded-full mix-blend-screen filter blur-[100px] animate-pulse"></div>
    <div class="absolute bottom-0 right-1/4 w-[500px] h-[500px] bg-purple-500/20 rounded-full mix-blend-screen filter blur-[100px] animate-pulse" style="animation-delay: 1s;"></div>
    
    <!-- 玻璃光澤主卡片 -->
    <div class="relative z-10 text-center backdrop-blur-md bg-white/10 p-16 rounded-3xl border border-white/20 shadow-[0_0_80px_rgba(139,92,246,0.4)] transform transition-transform duration-700 hover:scale-105">
      


      <!-- 發光標題 -->
      <h1 class="text-7xl md:text-9xl font-black mb-8 tracking-wider text-transparent bg-clip-text bg-gradient-to-r from-cyan-300 via-fuchsia-300 to-yellow-300 drop-shadow-[0_5px_5px_rgba(0,0,0,0.8)] filter">
        考試加油！！
      </h1>
      
      <!-- 副標題 -->
      <p class="text-2xl md:text-3xl text-indigo-100 font-medium tracking-widest opacity-90 transition-opacity duration-300 group-hover:opacity-100 drop-shadow-md">
        Believe in Yourself 💯
      </p>

      <!-- 按鈕裝飾 -->
      <div class="mt-12 flex justify-center space-x-4">
        <div class="px-8 py-3 rounded-full bg-white/5 text-white/90 text-sm font-semibold tracking-widest uppercase border border-white/20 shadow-inner backdrop-blur-sm relative overflow-hidden">
          <span class="relative z-10">You Got This!</span>
          <div class="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full animate-[shimmer_2s_infinite]"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes shimmer {
  100% { transform: translateX(100%); }
}
</style>
