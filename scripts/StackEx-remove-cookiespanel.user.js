// ==UserScript==
// @name        StackEx-remove-cookies-panel
// @namespace   custom
// @include     /^https?://.*\.?stackoverflow\.com/.*$/
// @include     /^https?://.*\.stackexchange\.com/.*$/
// @include     /^https?://serverfault\.com/.*$/
// @include     /^https?://superuser\.com/.*$/
// @include     /^https?://askubuntu\.com/.*$/
// @version     1
// @grant       none
// ==/UserScript==

// Seen a version at https://greasyfork.org/en/scripts/426258-hide-stackoverflow-com-privacy-panel/ which was made by Andy Cui
// That one does a bunch of work to hide things, so this script just tries to remove the panel div

var elList = document.querySelectorAll('.js-consent-banner');
elList.forEach(el => el.parentNode.removeChild(el));

