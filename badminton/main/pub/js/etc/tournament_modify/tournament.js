Math.log2 = Math.log2 || function(x) {
    return Math.log(x) * Math.LOG2E;
};

function Tournament(obj) {
    var that = this;
    this.options = {
        roundOf: 8,
        data: {},
        blockBoardWidth: 220,
        blockBranchWidth: 40,
        blockHeight: 80,
        branchWidth: 2,
        branchColor: '#a9afbf',
        roundOf_textSize: 60,
        scale: 'auto',
        board: true,
        el: {},
        limitedStartRoundOf: 0,
        limitedEndRoundOf: 0,
    }
    this.sheet = null;
}
Tournament.prototype.extend = function(obj, src) {
    if (!src) return obj;
    Object.keys(src).forEach(function(key) { obj[key] = src[key]; });
    return obj;
}
Tournament.prototype.setOption = function(obj) {
    this.options = this.extend(this.options, obj);
}
Tournament.prototype.draw = function(obj) {
    this.options = this.extend(this.options, obj);
    var data = Array.isArray(this.options.data) ? this.options.data : [this.options.data];

    var html = '<div class="tournament__inner">';
    for (var i = 0, ii = data.length; i < ii; i++) {
        if (Array.isArray(this.options.data)) html += '<div class="">';

        var startRoundOf = Math.round(this.options.limitedStartRoundOf ? this.options.limitedStartRoundOf : this.options.roundOf);
        var endRoundOf = Math.round(this.options.limitedEndRoundOf ? this.options.limitedEndRoundOf : 2);
        var round = Math.round(this.options.limitedStartRoundOf ? (Math.log2(this.options.roundOf) - Math.log2(startRoundOf)) + 1 : 1);

        for (var roundOf = startRoundOf, round = 1; roundOf >= endRoundOf; roundOf = roundOf / 2, round++) {

            if (round == 1 || this.options.board) {
                html += this.drawBoard(round, roundOf, data[i]['round_' + (Math.round((Math.log2(this.options.roundOf) - Math.log2(roundOf))) + 1)]);
            }

            if (roundOf == 2) { break; }

            html += this.drawTree(round, roundOf);

            html += this.drawTree2(round, roundOf);

        }
        if (Array.isArray(this.options.data)) html += '</div>';
    }
    html += '</div>';


    this.options.el.innerHTML = html;


    var tournament = this.options.el;
    var tournamentInner = this.options.el.getElementsByClassName('tournament__inner')[0];

    var tournamentWidth = tournament.getBoundingClientRect().width;
    var tournamentInnerWidth = tournamentInner.getBoundingClientRect().width;
    var tournamentInnerHeight = tournamentInner.getBoundingClientRect().height;

    if (this.options.scale == 'auto') {
        var agent = navigator.userAgent.toLowerCase();
        // if( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ){
        //   tournamentInner.style.zoom = (tournamentWidth/tournamentInnerWidth);
        // }
        // else{
        tournamentInner.style.transform = 'scale(' + (tournamentWidth / tournamentInnerWidth) + ')';
        // }
        tournament.style.height = (tournamentInnerHeight * tournamentWidth / tournamentInnerWidth) + 'px';


    } else {
        // tournamentInner.style = 'transform:scale('+this.options.scale+')';
        tournamentInner.style.transform = 'scale(' + this.options.scale + ')';
    }

}
Tournament.prototype.drawBoard = function(round, roundOf, data) {
    var html = '<ul class="tournament__round round_' + Number(round) + '">';
    for (var i = 0, ii = roundOf / 2; i < ii; i++) {
        var obj = { index: i };

        if (round == 1) {
            html += [
                '<li class="tournament__block tournament__block_board_first tournament__block_' + (Number(round) + 1) + '">',
                (round == 1 || roundOf == 1 || i % 2 == 0) ? '' : '<p class="tournament__roundOf">' + ((roundOf == 4) ? '준결승전' : roundOf + '강전') + '</p>',

                (data && data[i]) ? this.boardInner.call(obj, data[i]) : this.boardInner.call(obj),

                '</li>'
            ].join('');
        } else {
            html += [
                '<li class="tournament__block tournament__block_board tournament__block_' + (Number(round) + 1) + '">',
                (round == 1 || roundOf == 1 || i % 2 == 0) ? '' : '<p class="tournament__roundOf">' + ((roundOf == 4) ? '준결승전' : roundOf + '강전') + '</p>',

                (data && data[i]) ? this.boardInner.call(obj, data[i]) : this.boardInner.call(obj),

                '</li>'
            ].join('');
        }
    }
    html += '</ul>';
    return html;
}
Tournament.prototype.boardInner = function(data) {

    var html = [
        '<p class="ttMatch ttMatch_first">',
        '<span class="ttMatch__playerWrap">',
        '<span class="ttMatch__playerInner">',
        '<span class="ttMatch__player"></span>',
        '<span class="ttMatch__belong"></span>',
        '</span>',
        '</span>',
        '<span class="ttMatch__score"></span>',
        '</p>',
        '<p class="ttMatch ttMatch_second">',
        '<span class="ttMatch__playerWrap">',
        '<span class="ttMatch__playerInner">',
        '<span class="ttMatch__player"></span>',
        '<span class="ttMatch__belong"></span>',
        '</span>',
        '</span>',
        '<span class="ttMatch__score"></span>',
        '</p>'
    ].join('');

    return html;
}
Tournament.prototype.drawTree = function(round, roundOf) {
    var html = '<div class="tournament__round round_line round_' + Number(round) + '">';
    for (var i = 0, ii = roundOf / 4; i < ii; i++) {
        html += [
            '<div class="tournament__block tournament__block_branch tournament__block_' + (Number(round) + 2) + '">',
            '<div class="ttBranch">',
            '<span class="ttBranch__branch ttBranch__branch_top_right"></span>',
            '<span class="ttBranch__branch ttBranch__branch_bottom_right"></span>',
            '<span class="ttBranch__branch ttBranch__branch_top"></span>',
            '<span class="ttBranch__branch ttBranch__branch_bottom"></span>',
            '</div>',
            '</div>',
        ].join('');

    }
    html += '</div>';

    return html;
}
Tournament.prototype.drawTree2 = function(round, roundOf) {
    var html = '<div class="tournament__round round_' + (Number(round) + 1) + '">';
    for (var i = 0, ii = roundOf / 4; i < ii; i++) {

        html += [
            '<div class="tournament__block tournament__block_branch tournament__block_' + (Number(round) + 2) + '">',
            '<div class="ttBranch">',
            '<div class="ttBranch__branch ttBranch__branch_middle"></div>',
            '</div>',
            '</div>',
        ].join('');

    }
    html += '</div>';

    return html;
}
Tournament.prototype.remove = function() {
    this.options.el.innerHTML = '';
}
Tournament.prototype.on = function(target, fn) {
    switch (target) {
        case 'matchClick':
            this.event['matchClick'] = fn;
            break;
        default:
            throw Error('not invalid event');
    }
}
Tournament.prototype.setStyle = function(classSelector) {
    if (this.sheet) document.head.removeChild(this.sheet);
    this.sheet = document.createElement('style');
    var classSelector = (classSelector) ? classSelector + ' ' : '';
    var css = '';
    // css += '.tournament{transform:scale('+ options.scale +');}';
    for (var i = 0; i < 10; i++) {
        css += classSelector + '.tournament__block_' + (i + 1) + '{height:' + (this.options.blockHeight * Math.pow(2, i)) + 'px;}';
    }
    css += classSelector + '.tournament__block_branch{width: ' + this.options.blockBranchWidth + 'px;}';
    css += classSelector + '.tournament__block_board{width: ' + this.options.blockBoardWidth + 'px;}';
    css += classSelector + '.tournament__block_board_first{width: ' + this.options.blockBoardWidthFirst + 'px;}';
    css += classSelector + '.tournament__roundOf{font-size: ' + this.options.roundOf_textSize + 'px;}';

    css += classSelector + '.ttBranch{height:calc(50% + ' + this.options.branchWidth + 'px);}';
    css += classSelector + '.ttBranch__branch{border-color:' + this.options.branchColor + ';}';
    css += classSelector + '.ttBranch__branch_top{border-width:' + this.options.branchWidth + 'px 0 0 0;}';
    css += classSelector + '.ttBranch__branch_top_right{border-width: 0 ' + this.options.branchWidth + 'px 0 0;}';
    css += classSelector + '.ttBranch__branch_bottom_right{border-width: 0 ' + this.options.branchWidth + 'px 0 0;}';
    css += classSelector + '.ttBranch__branch_bottom{border-width: 0 0 ' + this.options.branchWidth + 'px 0;}';
    css += classSelector + '.ttBranch__branch_middle{border-width: ' + this.options.branchWidth / 2 + 'px 0 ' + this.options.branchWidth / 2 + 'px 0;}';

    this.sheet.innerHTML = css;
    document.head.appendChild(this.sheet);
}