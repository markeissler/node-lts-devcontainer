{
    "compilerOptions": {
        "target": "ES2022",
        "module": "ESNext",
        "moduleResolution": "Node", // ✅ Use "Node" instead of "Bundler" for editor compatibility
        "jsx": "react",
        "allowJs": true, // ✅ Enables JS support
        "checkJs": true, // ✅ Enables type-checking on JS files (needed for suggestions)
        "strictNullChecks": true,
        "strictFunctionTypes": true,
        "types": [
            "express",
            "node"
        ], // ✅ Load Node.js types (enables auto-imports for fs, path, etc.)
        "baseUrl": ".", // ✅ Needed for path aliases (if you want them)
        "paths": {
            "@/*": [
                "src/*"
            ] // ✅ Optional: setup for alias like '@/components/Button'
        }
    },
    "include": [
        "src",
        "vite.config.ts",
        "eslint.config.js"
    ], // ✅ Tell the editor where to look
    "exclude": [
        "node_modules",
        "**/node_modules/*"
    ]
}
