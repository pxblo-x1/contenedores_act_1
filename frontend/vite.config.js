import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import envCompatible from 'vite-plugin-env-compatible'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue(), envCompatible()],
  server: {
    host: true,
    port: 5173,
    allowedHosts: ['.', 'localhost', 'ubuntu-srv', '127.0.0.1'],
  },
})
