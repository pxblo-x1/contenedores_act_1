<template>
    <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-indigo-900 via-purple-900 to-slate-900 text-white p-6">
      <div class="w-full max-w-xl bg-white/10 backdrop-blur-md rounded-xl p-8 shadow-lg">
        <h1 class="text-3xl font-bold mb-6 text-center text-white">💸 Transacciones</h1>
  
        <form @submit.prevent="addTransaction" class="flex flex-col gap-4 mb-8">
          <input
            v-model="form.description"
            type="text"
            placeholder="Descripción"
            class="w-full bg-white/10 text-white placeholder-white/70 border border-white/30 rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-purple-400"
            required
          />
          <input
            v-model.number="form.amount"
            type="number"
            placeholder="Monto"
            step="0.01"
            class="w-full bg-white/10 text-white placeholder-white/70 border border-white/30 rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-purple-400"
            required
          />
          <button
            type="submit"
            class="w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-indigo-600 hover:to-purple-600 text-white font-semibold py-3 rounded-md shadow-lg transition transform hover:scale-105"
          >
            Agregar
          </button>
        </form>
  
        <ul class="divide-y divide-white/20">
          <li
            v-for="tx in transactions"
            :key="tx.id"
            class="py-2 flex justify-between"
          >
            <span>{{ tx.description }}</span>
            <span class="font-semibold">${{ tx.amount.toFixed(2) }}</span>
          </li>
        </ul>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import axios from 'axios'
  
  // Leer la variable de entorno
  const API_HOST = import.meta.env.VITE_API_HOST
  
  const form = ref({ description: '', amount: null })
  const transactions = ref([])
  
  const loadTransactions = async () => {
    const res = await axios.get(`${API_HOST}/transactions`)
    transactions.value = res.data
  }
  
  const addTransaction = async () => {
    await axios.post(`${API_HOST}/transactions`, form.value)
    form.value = { description: '', amount: null }
    await loadTransactions()
  }
  
  onMounted(() => {
    loadTransactions()
  })
  </script>