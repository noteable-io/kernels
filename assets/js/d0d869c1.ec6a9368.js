"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[625],{3905:(e,t,n)=>{n.d(t,{Zo:()=>l,kt:()=>b});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var u=r.createContext({}),c=function(e){var t=r.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},l=function(e){var t=c(e.components);return r.createElement(u.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,i=e.originalType,u=e.parentName,l=s(e,["components","mdxType","originalType","parentName"]),p=c(n),m=o,b=p["".concat(u,".").concat(m)]||p[m]||d[m]||i;return n?r.createElement(b,a(a({ref:t},l),{},{components:n})):r.createElement(b,a({ref:t},l))}));function b(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=n.length,a=new Array(i);a[0]=m;var s={};for(var u in t)hasOwnProperty.call(t,u)&&(s[u]=t[u]);s.originalType=e,s[p]="string"==typeof e?e:o,a[1]=s;for(var c=2;c<i;c++)a[c]=n[c];return r.createElement.apply(null,a)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},164:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>u,contentTitle:()=>a,default:()=>d,frontMatter:()=>i,metadata:()=>s,toc:()=>c});var r=n(7462),o=(n(7294),n(3905));const i={sidebar_position:1,title:"Before Contributing"},a=void 0,s={unversionedId:"contributor-guide/before-you-contribute",id:"contributor-guide/before-you-contribute",title:"Before Contributing",description:"Before beginning to contribute to Noteable kernels, please take some time and read through the documentation. Once you're",source:"@site/docs/contributor-guide/before-you-contribute.md",sourceDirName:"contributor-guide",slug:"/contributor-guide/before-you-contribute",permalink:"/kernels/contributor-guide/before-you-contribute",draft:!1,tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1,title:"Before Contributing"},sidebar:"tutorialSidebar",previous:{title:"Contributor Guide",permalink:"/kernels/category/contributor-guide"},next:{title:"FAQ",permalink:"/kernels/faq"}},u={},c=[{value:"Issue Tracking",id:"issue-tracking",level:3},{value:"Signed Commits",id:"signed-commits",level:3}],l={toc:c},p="wrapper";function d(e){let{components:t,...n}=e;return(0,o.kt)(p,(0,r.Z)({},l,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("p",null,"Before beginning to contribute to Noteable kernels, please take some time and read through the documentation. Once you're\ncomfortable with the tooling and structure, there are a few prerequisites before a pull request can be opened\nand reviewed"),(0,o.kt)("h3",{id:"issue-tracking"},"Issue Tracking"),(0,o.kt)("p",null,"Before addressing any issues, or possibly creating a new kernel image, discussion must occur on an issue first. If\nthere isn't an open issue regarding your change, feel free to create one to start a conversation with the project\nmaintainers. Since these kernels run on the Noteable platform, certain decisions around languages, supported versions,\nand other topics must be made before changes can be made."),(0,o.kt)("h3",{id:"signed-commits"},"Signed Commits"),(0,o.kt)("p",null,"All commits to the ",(0,o.kt)("inlineCode",{parentName:"p"},"noteable-io/kernels")," repository must be signed. If you don't have commit signing setup\non your workstation, please follow ",(0,o.kt)("a",{parentName:"p",href:"https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits"},"Signing Commits"),"\nto do so."),(0,o.kt)("p",null,"All other style and usage guidelines covered in this documentation apply to Pull Requests by all contributors, both\nexternal and internal."))}d.isMDXComponent=!0}}]);