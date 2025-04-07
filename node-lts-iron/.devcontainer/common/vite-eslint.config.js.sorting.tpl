// eslint.config.js
//
// This configuration supports JavaScript React projects with auto-sorting of
//  imports and React best practices.

import js from '@eslint/js';
import globals from 'globals';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';
import importPlugin from 'eslint-plugin-import';
import importConfig from 'eslint-plugin-import/config/flat/react.js';
import simpleImportSort from 'eslint-plugin-simple-import-sort';

export default [
  {
    ignores: ['dist'],
  },
  {
    files: ['**/*.{js,jsx}'],
    languageOptions: {
      ecmaVersion: 2020,
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
    settings: {
      react: {
        version: 'detect',
      },
      'import/resolver': {
        alias: {
          map: [
            ['', './public'], // Map root imports to the `public/` folder.
          ],
          extensions: ['.js', '.jsx', '.svg', '.png', '.jpg'],
        },
      },
    },
    plugins: {
      react,
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
      import: importPlugin,
      'simple-import-sort': simpleImportSort,
    },
    extends: [
      js.configs.recommended,
      importConfig,
      react.configs.recommended,
    ],
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],

      // Resolve imports properly
      'import/no-unresolved': 'error',

      // Auto-sort imports
      'simple-import-sort/imports': [
        'error',
        {
          groups: [
            ['^node:.*', '^fs', '^path', '^[a-z]'], // Node built-ins
            ['^react', '^@react'], // React packages
            ['^@?\\w'], // External packages
            ['^@my_org/'], // Internal aliases
            ['^\\.\\.?(?!/node_modules)'], // Parent imports
            ['^\\./'], // Relative imports
            ['^\\u0000'], // Side-effect imports
          ],
        },
      ],
      'simple-import-sort/exports': 'error',
      'import/order': 'off', // Disabled in favor of simple-import-sort
    },
  },
];
