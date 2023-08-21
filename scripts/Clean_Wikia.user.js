// ==UserScript==
// @name          Clean Wikia
// @namespace     http://userstyles.org
// @description	  Removes sidebar cruft (while retaining the search box), wikia navigation (e.g. links to other wikia wikis), and ads.  <strike>Expands article navigation</strike>* and makes content full-width.
// @author        Phoenixsong
// @homepage      https://userstyles.org/styles/75857
// @include       http://wikia.com/*
// @include       https://wikia.com/*
// @include       http://*.wikia.com/*
// @include       https://*.wikia.com/*
// @run-at        document-start
// @version       0.20131230215027
// ==/UserScript==
(function() {var css = [
	"/* Full width content */",
	"	#WikiaPage{width:100%!important;max-width:none!important;margin:0px!important}",
	"	#WikiaMainContent{width:100%!important;margin:0px!important}",
	"	#WikiaMainContentContainer{margin:0px!important}",
	"	#WikiaPageHeader{padding-left:10px!important}",
	"",
	"	/* Expand article navigation */",
	"	.toc ul{display:block!important}",
	"",
	"	/* Remove wikia navigation */",
	"	#WikiaFooter{display:none!important}",
	"	#WikiaHeader nav {display:none!important}",
	"	.CorporateFooter{display:none!important}",
	"	#WikiaBarWrapper{display:none!important}",
	"	body{padding:0px!important}",
	"	.oasis-split-skin .WikiaHeader .page-width-container{width:auto!important}",
	"	#WikiaHeader{min-width:0!important}",
	"	#UserLoginDropdown{right:0!important}",
	"	.WikiHeader .navbackground{width:100%!important}",
	"	.WikiHeader .WikiNav .nav ul{width:auto!important}",
	"	#AccountNavigation{top:32px!important}",
	"",
	"	/* Remove sidebar cruft */",
	"	.WikiaRail{float:none!important;position:absolute!important;right:10px!important;z-index:1000!important;overflow:visible!important}",
	"	.wikinav2 .WikiaPageHeader > .tally{right:350px!important}",
	"	.WikiaRail > div, .WikiaRail > section{display:none!important}",
	"",
	"	/* Cinch up page, remove image frills */",
	"	.page-width-container img{display:none!important}",
	"	#WikiaHeader{border:none!important}",
	"	.WikiNav, .buttons{top:0px!important}",
	"	.navbackground img{display:none!important}",
	"	.WikiaPage{border:none!important}",
	"	.WikiHeaderRestyle{padding:0px!important;margin:0px!important}",
	"	.WikiaArticle{padding: 0 10px!important}",
	"	body.mediawiki{background-image: none!important}",
	"",
	"	/* Remove ads */",
	"	.wikia-ad{display:none!important}",
	"	.home-top-right-ads{display:none!important}",
	"	#WikiaTopAds{display:none!important}",
	"	#WikiaArticleBottomAd{display:none!important}",
	"	#WikiaNotifications{display:none!important}"
].join("\n");
if (typeof GM_addStyle != "undefined") {
	GM_addStyle(css);
} else if (typeof PRO_addStyle != "undefined") {
	PRO_addStyle(css);
} else if (typeof addStyle != "undefined") {
	addStyle(css);
} else {
	var node = document.createElement("style");
	node.type = "text/css";
	node.appendChild(document.createTextNode(css));
	var heads = document.getElementsByTagName("head");
	if (heads.length > 0) {
		heads[0].appendChild(node); 
	} else {
		// no head yet, stick it whereever
		document.documentElement.appendChild(node);
	}
}
})();
