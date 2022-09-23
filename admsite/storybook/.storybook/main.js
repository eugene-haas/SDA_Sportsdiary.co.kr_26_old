const path = require('path');
module.exports = {
   "stories": [
      "../src/**/*.stories.mdx", "../src/**/*.stories.@(js|jsx|ts|tsx)"
   ],
   "addons": [
      '@whitespace/storybook-addon-html', "@storybook/addon-links", "@storybook/addon-essentials", "@storybook/addon-viewport/register", "@storybook/addon-knobs/register", '@etchteam/storybook-addon-status/register'
   ],
   webpackFinal: async config => {
      // Remove the existing css rule
      config.module.rules = config.module.rules.filter(f => f.test.toString() !== '/\\.css$/');

      config.module.rules.push({
         test: /\.css$/,
         use: [
            'style-loader', {
               loader: 'css-loader'
               // options: {
               //    modules: {
               //       localIdentName: "[local]"
               //    }
               // }
            }
         ],
         include: path.resolve(__dirname, '../src')
      });

      return config;
   }
}
