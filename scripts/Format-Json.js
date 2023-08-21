/*
 * Bookmarklet which formats a JSON.
 * TODO: Look up where this came from to credit the source and format it a bit better.
 */
javascript:!function(){var n,e,r,i;n=window,e=document.body,r=JSON.parse,i=JSON.stringify,n.isf||(e.innerHTML=&quot;<pre>&quot;+i(r(e.innerText),null,4).replace(/\&quot;(.*)[^\:]\:/g,'<span style=&quot;color:#9C3636&quot;>$1&colon;</span>')+&quot;</pre>&quot;,n.isf=!0)}();
