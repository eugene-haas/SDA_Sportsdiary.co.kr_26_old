//webpack.config.js
const path = require('path');
module.exports = async ({config, mode}) => {
   config.resolve.extensions.push('.ts', '.tsx', '.vue', '.css', '.less', '.scss', '.sass', '.html');
   config.resolve.alias = {
      ...config.resolve.alias,
      "@": path.resolve(__dirname, "../src")
   };
   
   return config;
}
