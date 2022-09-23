({
	cssIn : "import.css",
	out   : "style.min.css",
	// cssIn : "./src/tennis_style.css",
	// out   : "./dist/tennis_style.min.css",
	/**
	 * --------------------------------
	 * 사용 가능한 옵션
	 * https://github.com/jrburke/r.js/blob/master/build/example.build.js#L218
	 * --------------------------------
	 * 모두 압축: ""
	 * 라인 유지: "standard.keepLines"
	 * 주석 유지: "standard.keepComments"
	 * 라인/주석 유지: "standard.keepComments.keepLines"
	 * 공백 유지: "standard.keepWhitespace"
	 * --------------------------------
	 */
	// optimizeCss: "standard.keepComments.keepLines",
	optimizeCss: "standard.keepComments.keepLines",
	cssImportIgnore: null

	/**
	 * --------------------------------
	 * node r.js -o build-css.js 라고 cli 창에 입력!
	 * --------------------------------
	 */
	
})