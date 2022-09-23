import { addons } from '@storybook/addons';
import { themes } from '@storybook/theming';
themes.dark.brandTitle =  'WIDLINE';
themes.dark.brandUrl = 'http://www.widline.co.kr/pc/';
themes.dark.brandImage = 'http://www.widline.co.kr/pc/front/imgs/logo.png';
addons.setConfig({
  theme: themes.dark,
});
