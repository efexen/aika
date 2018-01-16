const Merge = require("webpack-merge");
const Common = require("./webpack.common.js");
const CompressionPlugin = require("compression-webpack-plugin");
const Webpack = require("webpack");

module.exports = Merge(Common, {
  plugins: [
    new Webpack.optimize.UglifyJsPlugin({
      comments: false,
      sourceMap: false,
      minimize: true
    }),
    new CompressionPlugin({
      asset: "[path].gz[query]",
      algorithm: "gzip",
      test: /\.(js|html|css)$/
    }),
    new Webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    })
  ]
});
