// eslint.config.js
//
// This configuration supports Typescript and auto-sorting of imports for React
// projects.
//
import js from '@eslint/js';
import globals from 'globals';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';
import tseslint from 'typescript-eslint';
import importPlugin from 'eslint-plugin-import';
import importConfig from 'eslint-plugin-import/config/flat/react.js';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import { version } from 'os';
import typescript from 'eslint-plugin-import/config/typescript.js';

export default tseslint.config(
  { ignores: ['dist'] },
  {
    extends: [
      js.configs.recommended,
      ...tseslint.configs.recommended,
      importConfig,
    ],
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2020,
      //   globals: globals.browser,
      globals: { ...globals.browser, ...globals.node },
    },
    settings: {
      'import/resolver': {
        alias: {
          map: [
            ['', './public'], // Map root imports to the `public/` folder.
          ],
          extensions: ['.js', '.jsx', '.ts', '.tsx', '.svg', '.png', '.jpg'],
        },
        typescript: {
          alwaysTryTypes: true,
          project: './tsconfig.json',
        },
      },
      react: {
        version: 'detect',
      },
    },
    plugins: {
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
      import: importPlugin,
      'simple-import-sort': simpleImportSort,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
      // Ensure ESLint resolves TypeScript imports correctly.
      'import/no-unresolved': 'error',

      'simple-import-sort/imports': [
        'error',
        {
          groups: [
            // 1️⃣ Built-in node modules
            ['^node:.*', '^fs', '^path', '^[a-z]'],

            // 2️⃣ React-related packages
            ['^react', '^@react'],

            // 3️⃣ External packages (everything else from node_modules)
            ['^@?\\w'],

            // 4️⃣ Internal imports (aliases like @my_org/**)
            ['^@my_org/'],

            // 5️⃣ Parent imports (`../`)
            ['^\\.\\.?(?!/node_modules)'],

            // 6️⃣ Relative imports (`./`)
            ['^\\./'],

            // 7️⃣ Side-effect imports (e.g., `import "./styles.css";`)
            ['^\\u0000'],
          ],
        },
      ],

      'simple-import-sort/exports': 'error',

      // Optional: Disable `import/order` since `simple-import-sort` replaces it
      'import/order': 'off',
    },
  },
);
