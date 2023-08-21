// ==UserScript==
// @name        StackEx-remove-network-questions
// @namespace   custom
// @include     /^https?://.*\.?stackoverflow\.com/.*$/
// @include     /^https?://.*\.stackexchange\.com/.*$/
// @include     /^https?://serverfault\.com/.*$/
// @include     /^https?://superuser\.com/.*$/
// @include     /^https?://askubuntu\.com/.*$/
// @version     1
// @grant       none
// ==/UserScript==

var elmDeleted = document.getElementById("hot-network-questions");
elmDeleted.parentNode.removeChild(elmDeleted);

