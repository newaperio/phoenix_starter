module.exports = {
  env: {
    es6: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/recommended",
    "plugin:prettier/recommended",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: 6,
    sourceType: "module",
  },
  plugins: ["prettier", "@typescript-eslint"],
  root: true,
  rules: {
    "prefer-const": "error",
    "prettier/prettier": "error",
  },
  settings: {
    "import/resolver": {
      node: {
        extensions: [".ts"],
      },
    },
  },
}
