module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: ["plugin:vue/vue3-essential", "airbnb-base", "plugin:prettier/recommended"],
  overrides: [],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module"
  },
  plugins: ["vue"],
  rules: {
    "import/no-unresolved": "off",
    "import/extensions": "off",
    "import/no-absolute-path": "off",
    "import/no-extraneous-dependencies": "off",
    "vue/multi-word-component-names": "off",
    "no-console": "off",
    "no-use-before-define": "off"
  }
}
