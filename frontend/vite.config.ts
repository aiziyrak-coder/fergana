import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

const DEFAULT_PROD_API = 'https://ferganaapi.ziyrak.org/api';

export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, '.', '');
    const define: Record<string, string> = {
        'process.env.API_KEY': JSON.stringify(env.GEMINI_API_KEY || env.VITE_GEMINI_API_KEY),
        'process.env.GEMINI_API_KEY': JSON.stringify(env.GEMINI_API_KEY || env.VITE_GEMINI_API_KEY),
        'import.meta.env.VITE_GEMINI_API_KEY': JSON.stringify(env.VITE_GEMINI_API_KEY || env.GEMINI_API_KEY),
    };
    if (mode === 'production') {
        const apiBase = (env.VITE_API_BASE_URL || '').trim() || DEFAULT_PROD_API;
        define['import.meta.env.VITE_API_BASE_URL'] = JSON.stringify(apiBase);
    }
    return {
      server: {
        port: 3000,
        host: '0.0.0.0',
      },
      plugins: [react()],
      define,
      resolve: {
        alias: {
          '@': new URL('.', import.meta.url).pathname,
        }
      },
      build: {
        rollupOptions: {
          output: {
            // Generate unique filenames with hash for cache busting
            entryFileNames: 'assets/[name]-[hash].js',
            chunkFileNames: 'assets/[name]-[hash].js',
            assetFileNames: 'assets/[name]-[hash].[ext]'
          }
        }
      }
    };
});
