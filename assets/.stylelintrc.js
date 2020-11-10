module.exports = {
  extends: "stylelint-config-standard",
  plugins: ["stylelint-order"],
  rules: {
    "at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: ["define-mixin", "mixin", "layer"],
      },
    ],
    "declaration-colon-newline-after": "always-multi-line",
    "declaration-empty-line-before": "never",
    "order/properties-alphabetical-order": true,
  },
}
