({
  baseUrl: ".",
  name: "libs/almond",
  include: ["main"],
  insertRequire: ["main"],
  out: "main.out.js",
  wrap: true,
  optimize: "none",
  paths: {
    'coffee-script': "libs/coffee-script-1.6.1",
    cson: "../lib/cson"
  },
  stubModules: [
    "coffee-script",
    "cson"
  ]
})