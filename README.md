require-cson
============
[http://github.com/paulyoung/require-cson](http://github.com/paulyoung/require-cson)

A [RequireJS](http://requirejs.org/) plugin for loading [CSON](https://github.com/bevry/cson) files. Inspired by the RequireJS [JSON plugin](https://github.com/millermedeiros/requirejs-plugins/blob/master/src/json.js).

## Usage
```js
define(['cson!data'], function(data) {
  return data.key;
});
```
