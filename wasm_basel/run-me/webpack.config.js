const HtmlWebpackPlugin = require("html-webpack-plugin");
const NodePolyfillPlugin = require("node-polyfill-webpack-plugin")

const path = require("path");

module.exports = {
  entry: "./index.ts",
  mode: "development",
  output: {
    filename: "./bundle.js",
    path: path.resolve(__dirname, "dist"),
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./index.html",    
    }),
    new NodePolyfillPlugin(),

  ],
  resolve: {
    modules: [__dirname, "js",  "node_modules"],
    extensions: [ ".js", ".jsx", ".tsx", ".ts"],
  },
  module: {
    rules: [
      {
        test: /\.(tsx|ts)?$/,
        exclude: /node_modules/,
        use: ["babel-loader"],

      },
      {
        test: /\.css$/,
        exclude: /node_modules/,
        use: ["style-loader", "css-loader"]
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        exclude: /node_modules/,
        use: ["file-loader"]
      }, 
    ],
  },
  
  
  //target: 'node'

};