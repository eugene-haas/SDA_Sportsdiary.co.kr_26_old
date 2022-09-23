import { INITIAL_VIEWPORTS } from "@storybook/addon-viewport";
function getLink(href){
   let obj = document.createElement('link');
   obj.rel  = 'stylesheet';
   obj.name= 'stylesheet';
   obj.type = 'text/css';
   obj.href = href;
   return obj;
}
function getScript(src){
   let obj = document.createElement('script');
   obj.src = src;
   return obj;
}
setTimeout(function(){
   css_load();
   const observer = new MutationObserver(function(mutations) {
     mutations.some(function(mutation) {
       if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
         var head = document.getElementsByTagName('head')[0];
         var links = document.querySelectorAll('[rel="stylesheet"]');
         if (!links) {
           links = []
         }
         for (var i = 0; i < links.length; i++) {
           head.removeChild(links[i]);
         }
         css_load();
         return true;
       }

       return false;
     });
   }).observe(document.children[0], { attributes: true, childList: true, subtree: true });
   function css_load(){
      var head  = document.getElementsByTagName('head')[0];
      if (window.location.search.indexOf('knsu') !== -1 && window.location.search.indexOf('knsu-introduction') === -1) {

         head.appendChild(getLink('http://knsu.sportsdiary.co.kr/main/css/style.css?ver=1.0.4.1'));

         head.appendChild(getLink('http://knsu.sportsdiary.co.kr/main/css/default.css?ver=1.0.4.1'));

         head.appendChild(getLink('http://img.sportsdiary.co.kr/css/fonts.css?ver=1.0.4.1'));
         head.appendChild(getScript('http://knsu.sportsdiary.co.kr/main/js/etc/default.js?ver=1.0.3.5'))
         var head = document.getElementsByTagName('head')[0];
         var links = document.querySelectorAll('head>style:nth-child(17)');
         if (!links) {
           links = []
         }
         for (var i = 0; i < links.length; i++) {
           head.removeChild(links[i]);
         }
      }
      if (window.location.search.indexOf('sportsdiary-app') !== -1 && window.location.search.indexOf('sportsdiary-app-introduction') === -1) {
         head.appendChild(getLink('http://sdmain.sportsdiary.co.kr/app/css/style.css?ver=1.0.1.0'));

         head.appendChild(getLink('http://sdmain.sportsdiary.co.kr/app/css/default.css?ver=1.0.1.0'));
         head.appendChild(getLink('http://sdmain.sportsdiary.co.kr/app/css/reset.css?ver=1.0.1.0'));

         head.appendChild(getLink('http://sdmain.sportsdiary.co.kr/app/css/fonts.css?ver=1.0.1.0'));

         head.appendChild(getLink('http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css'));
      }
   }
},0);
export const parameters = {
   actions: {
      argTypesRegex: "^on[A-Z].*"
   },
   html: {
      prettier: {
         tabWidth: 3,
         useTabs: false,
      }
   },
   viewport: {
     viewports: INITIAL_VIEWPORTS,
   },
   options: {
      storySort: {
         method: '',
         order: ['Docs', ['Introduction'], 'sportsdiary_APP', ['Introduction'], 'AWS', ['Introduction'], 'KNSU', ['Introduction'], 'Example'],
         locales: '',
      },
   },
}
