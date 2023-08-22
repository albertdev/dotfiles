/*
	Bookmarklet which either opens Mobile Vikings data usage page,
	or switches to the data usage of the day before if that page is already open.
*/
javascript:(
function () {
	const regex = /^.*mobilevikings\.be\/[^?]+\/usage\?start=([-0-9]+)/g;
	var currentDateMatch = regex.exec(window.location);
	if (currentDateMatch) {
		/* Remove everything after start= */
		var baseURL = currentDateMatch[0].substring(0, currentDateMatch[0].lastIndexOf("=") + 1);
		var date = new Date(currentDateMatch[1]);
		date.setDate(date.getDate() - 1);
		var isoDate = date.toISOString().split("T")[0];
		var targetURL = baseURL + isoDate + "&end=" + isoDate + "&paid_only=false";
		//console.log(targetURL);
		window.location = targetURL;
	} else {
		window.open('https://mobilevikings.be/nl/my-viking/sims/usage');
	}
}
)()