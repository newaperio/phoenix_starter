module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
    "./js/**/*.ts",
    "./js/**/*.tsx",
  ],
  theme: {
    extend: {
      backgroundOpacity: {
        40: "0.4",
      },
      zIndex: {
        1: 1,
      },
    },
  },
  variants: {},
  plugins: [],
}
