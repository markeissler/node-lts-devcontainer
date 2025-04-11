// eslint.config.js
//
// This configuration supports JavaScript React projects with auto-sorting of
//  imports and React best practices.

import importPlugin from 'eslint-plugin-import';
import importConfig from 'eslint-plugin-import/config/flat/react.js';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import globals from 'globals';

import js from '@eslint/js';

export default [
  { ignores: ["dist"] },
  js.configs.recommended,
  importConfig,
  // react.configs.recommended,
  {
    files: ['**/*.{js,jsx}'],
    languageOptions: {
      ecmaVersion: 2020,
      globals: { ...globals.browser, ...globals.node },
    },
    settings: {
      'import/resolver': {
        alias: {
          map: [
            ['', './public'], // Map root imports to the `public/` folder.
          ],
          extensions: ['.js', '.jsx', '.svg', '.png', '.jpg'],
        },
        node: {
          extensions: ['.js', '.jsx'],
        },
      },
      react: {
        version: 'detect',
      },
    },
    plugins: {
      react: react,
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

      // Resolve imports properly.
      'import/no-unresolved': 'error',

      // Auto-sort imports
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

      // Optional: Disable `import/order` since `simple-import-sort` replaces it.
      'import/order': 'off',
    },
  },
];
