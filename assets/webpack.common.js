const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const Path = require("path");

module.exports = {
  entry: {
    app: "./js/app.js",
    homepage: "./js/homepage.js"
  },
  output: {
    path: Path.resolve(__dirname, "../priv/static"),
    filename: "js/[name].js"
  },

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        include: __dirname,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["env", "stage-3"]
          }
        }
      },
      {
        test: /\.(sass|scss)$/,
        exclude: /node_modules/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader", "resolve-url-loader", "sass-loader?sourceMap"]
        })
      },

      {
        test: /\.(jpg|jpeg|gif|png|svg)$/,
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 10000
            }
          }
        ]
      }
    ]
  },

  resolve: {
    modules: ["node_modules", __dirname + "/web/static/js"],

    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  },

  plugins: [
    new ExtractTextPlugin("css/[name].css"),
    new CopyWebpackPlugin([
      {from: "./static", to: Path.resolve(__dirname, "../priv/static")}
    ])
  ]
};
