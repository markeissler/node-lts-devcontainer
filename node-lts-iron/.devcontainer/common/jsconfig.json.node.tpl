{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Node", // ✅ Use "Node" instead of "Bundler" for editor compatibility
    "allowJs": true, // ✅ Enables JS support
    "checkJs": true, // ✅ Enables type-checking on JS files (needed for suggestions)
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "baseUrl": ".", // ✅ Needed for path aliases (if you want them)
    "paths": {
      "@/*": [
        "src/*"
      ] // ✅ Optional: setup for alias like '@/components/Button'
    }
  },
  "include": [
    "src/**/*",
    "eslint.config.js"
  ], // ✅ Tell the editor where to look
  "exclude": [
    "node_modules",
    "**/node_modules/*"
  ]
}
