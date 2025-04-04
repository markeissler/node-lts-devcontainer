import { loadEnv } from 'vite';
import { defineConfig, type ViteUserConfig } from 'vitest/config';

import react from '@vitejs/plugin-react';

export default defineConfig(({ mode }): ViteUserConfig => {
  // Load env file based on `mode` in the current working directory.
  // Set the third parameter to '' to load all env regardless of the
  // `VITE_` prefix.
  const env = loadEnv(mode, process.cwd(), '');

  const API_URL = `${env.VITE_API_URL ?? 'http://localhost:8081'}`;
  const PORT = parseInt(`${env.VITE_PORT ?? '3000'}`);

  return {
    // vite config
    define: {
      __API_URL__: JSON.stringify(API_URL),
      __APP_ENV__: JSON.stringify(env.APP_ENV),
    },
    envDir: '../',
    plugins: [react()] as ViteUserConfig['plugins'],
    server: {
      port: PORT,
      proxy: {
        '/api': {
          target: API_URL,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
          secure: false,
        },
      },
    },
    test: {
      environment: 'jsdom',
      globals: true,
      setupFiles: './vitest.setup.ts',
      exclude: ['node_modules', 'dist', '.git', 'coverage', 'build', 'public'],
      include: ['src/**/*.{test,spec}.{js,ts,jsx,tsx}'],
      //   cache: {
      //     dir: '/tmp',
      //   },
      pool: 'vmThreads',
      poolOptions: {
        isolate: false,
        singleFork: true,
        vmThreads: {
          maxThreads: 4, // Adjust based on your system
          minThreads: 4, // Helps balance performance
          useAtomics: true,
          memoryLimit: '3000MB',
          execArgv: ['max-old-space-size=4096'],
        },
      },
    },
  };
});
