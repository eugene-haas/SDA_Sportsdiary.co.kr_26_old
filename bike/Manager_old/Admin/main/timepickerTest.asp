

<script type="text/javascript" src="../js/jquery-1.12.2.min.js"></script>
<link rel="stylesheet" href="../css/lib/jquery.timepicker.min.css">

<script type="text/javascript" src="../js/library/jquery.timepicker.min.js"></script>

<script>
(function($) {
    $(function() {
        $('input.timepicker').timepicker();
    });
})(jQuery);

$('.timepicker').timepicker({timeFormat:'h:i A'});
$('#trigger-bootstrap-modal').on('click', function() {
    $('#my-modal').modal();
});
$( 'body' ).on( 'show', '.modal', function( event ) {
    var $this = $( this );
    if( $this.is( event.target ) ) {
        $this.css( 'top', $( window ).scrollTop() + 100 );
    }
} );

</script>


<form>
    <input type="text" class="timepicker" name="time"/>
</form>


<div class="modal hide fade" id="my-modal" tabindex="-1">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Some modal</h3>
    </div>

    <div class="modal-body" style="padding-top:50px; padding-bottom:100px;">
        <input type="text" class="timepicker" style="z-index:9999;"/>
    </div>
</div>

<div style="padding:100px;">
    <button id="trigger-bootstrap-modal">Show bootstrap modal</button>
</div>


