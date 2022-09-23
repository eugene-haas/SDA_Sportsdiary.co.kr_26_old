/**
 * =====================================================
 * 페이징
 * =====================================================
 */
Paging = function(target, totCnt, countPerPage, curPage) {
	// 페이징이 포함될 항목
	this.target = target;
	
	// Block Size
	// 한번에 10개의 페이지 링크를 보여준다.
	this.blockLimit = 10;
	
	// 전체 게시물 게수
	this.totalCount = parseInt(totCnt);
	
	// 한페이지에 보일 게시물 개수
	this.rowLimit = parseInt(countPerPage);
	
	// 현재 페이지
	this.curPage = (curPage==null || curPage=="") ? 1 : parseInt(curPage);
	
	// 전체 페이지 수
	this.totalPage = 1;
	
	// 전체 블럭 사이즈
	this.blockSize = "";
	
	// 현재 블럭
	this.curBlock = "";
	
	// 이전 블럭
	this.prevBlock = "";
	
	// 다음 블럭
	this.nextBlock = "";
	
	// 페이지 시작번호
	this.pageStart = "";
	
	// 페이지 끝번호
	this.pageEnd = "";
	
	// 전체 페이지수 확인
	if(this.totalCount > this.rowLimit) {
		this.totalPage = Math.ceil(this.totalCount / this.rowLimit);
	} else {
		this.totalPage = 1;
	}
	
	// 블럭 사이즈 설정
	this.blockSize = Math.ceil(this.totalPage / this.blockLimit);
	
	// 페이지시작 설정
	this.pageStart = Math.ceil(this.curPage / this.blockLimit);
	if(this.pageStart==0)
		this.pageStart = 1;
	else
		this.pageStart = (this.pageStart-1)*this.blockLimit + 1;
		
	// 페이지끝 설정
	this.pageEnd = (this.pageStart-1 + this.blockLimit < this.totalPage ? this.pageStart-1 + this.blockLimit : this.totalPage);
	
	//alert("Current Page : " + this.curPage + " / Page Start : " + this.pageStart + " / Page End : " + this.pageEnd);
}

Paging.prototype = {
	/*
	 * 페이징 소스를 리턴한다.
	 */
	getPageString: function() {
		var retval = "<table style='padding-top:10px;'><tr>";
		//retval += "<tr height='5'><td></td></tr>";
		
		retval += this.getFirstPage();
		retval += this.getPrevPage();
		for(var idx=this.pageStart; idx<=this.pageEnd; idx++)
			retval += this.getPage(idx);
		retval += this.getNextPage();
		retval += this.getLastPage();
		
		//retval += "<tr height='20'><td></td></tr>";
		retval += "</tr></table>";
		return retval;
	},
	
	/*
	 * 처음 페이지로 이동
	 */
	getFirstPage: function() {
		var src = "";
		src = "<td style='padding:0px 3px; 0px; 3px;'><a href='javascript:" + this.target + "(1);'><span class='page_link'>처음</span></a></td>";
		return src;
	},
	
	/*
	 * 마지막 페이지로 이동
	 */
	getLastPage: function() {
		var src = "";
		src = "<td style='padding:0px 3px; 0px; 3px;'><a href='javascript:" + this.target + "(" + this.totalPage + ");'><span class='page_link'>마지막</span></a></td>";
		return src;
	},
	
	/*
	 * 이전 페이지로 이동
	 */
	getPrevPage: function() {
		var src = "";
		
		// 현재페이지가 1보다 크면 링크를 입혀서 리턴
		if(this.curPage>1)
			src = "<td style='padding:0px 3px; 0px; 3px;'><a href='javascript:" + this.target + "(" + (this.curPage-1) + ");'><span class='page_link'>이전</span></a></td>";
		else
			src = "<td style='padding:0px 3px; 0px; 3px;'><span class='page_link'>이전</span></td>";
		
		return src;
	},
	
	/*
	 * 다음 페이지로 이동
	 */
	getNextPage: function() {
		var src = "";
		
		// 현재페이지가 전체페이지수 보다 작으면 링크를 입혀서 리턴
		if(this.curPage<this.totalPage)
			src = "<td style='padding:0px 3px; 0px; 3px;'><a href='javascript:" + this.target + "(" + (this.curPage+1) + ");'><span class='page_link'>다음</span></a></td>";
		else
			src = "<td style='padding:0px 3px; 0px; 3px;'><span class='page_link'>다음</span></td>";
		
		return src;
	},
	
	/*
	 * 지정한 페이지로 이동
	 */
	getPage: function(page) {
		var src = "";
		src = "<td style='padding:0px 3px; 0px; 3px;'><a href='javascript:" + this.target + "(" + page + ");'>";
		if(page==this.curPage)
			src += "<b><span class='page_link'>" + page + "</span></b>";
		else
			src += "<span class='page_link'>" + page + "</span>";
			
		src += "</a></td>";
		return src;
	}
}