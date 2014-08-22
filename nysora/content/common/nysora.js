$(function() {
    
    //Attach fastclick
    FastClick.attach(document.body);

    //Set the swf replacement (even though ios can't handle swf, video-js malfunctions if this path isnt set)
    videojs.options.flash.swf = "content/common/video-js.swf";


    var nysora = initNysora();
    nysora.initImageOverlay();
    nysora.interceptLinkTaps();

});

function initNysora() {
    var _private = {
        openImageOverlayWithProperties : function(imgSrc, imgHeight, imgWidth, captionText) {
            //Add class to activate the blur effect
            $('.content').addClass('active');
            //Add image to the overlay
            $('.img-overlay').find('.img-wrapper').html('<img class="img-responsive" src="' + imgSrc + '" height="' + imgHeight + '" width="' + imgWidth + '"></img>');
                             
            //Add the caption
            $('.img-overlay').find('.caption-text').html(captionText);

            //Set the event listener for toggle caption button
            $('.caption-button').on('click', function(e) {
                $('.img-overlay').find('.caption-text').toggle();
                $('.img-overlay').find('.caption-button').children('i').toggleClass('fa-angle-double-down');
                $('.img-overlay').find('.caption-button').children('i').toggleClass('fa-angle-double-up');                    
                //Move everything up
                $('.img-overlay').css({'margin-top' : "-" + $('.img-overlay').height()/2 + 'px'});
            });

            //Move the overlay
            $('.img-overlay').css({'margin-top' : "-" + $('.img-overlay').height()/2 + 'px'});

            //Activate the img overlay
            $('.img-overlay').addClass('active');

            $('.close-btn').on('click', function(g) {
                //Remove the blur
                $('.content').removeClass('active');
                //Remove the overlay
                $('.img-overlay').removeClass('active');
                //Remove the handlers
                $('.close-btn').off('click');
                $('.caption-button').off('click');
            });

            //Add the event listener to close the overlay, and make sure no other clicks are processed
            $('body').on('click', function(g) {
                g.preventDefault();
                if($(g.target).hasClass('close-btn') || $(g.target).parents('.close-btn').length > 0) {

                }
            });
        },
        initImageOverlay : function() {
            $('.img-wrapper').on('click', function(e) {
                if(!$('.content').hasClass('active')) {
                    //Get img properties
                    var imgSrc = $(e.target).parents('.img-wrapper').find('img').attr('src');
                    var imgHeight =  $(e.target).parents('.img-wrapper').find('img').height();
                    var imgWidth = $(e.target).parents('.img-wrapper').find('img').width();
                    var captionText = $(e.target).parents('.img-wrapper').find('.caption').html();
                    _private.openImageOverlayWithProperties(imgSrc, imgHeight, imgWidth, captionText);
                }
            });
        },
        interceptLinkTaps : function() {
            $('.img-link').on('click', function(e) {
                //Get a handle to the img
                var selImg = $('[data-img-id="' + $(e.target).attr('data-link-to') + '"]');
                //Get the info we need
                //1. imgSrc
                var imgSrc = selImg.parents('.img-wrapper').find('img').attr('src');
                var imgHeight = selImg.parents('.img-wrapper').find('img').height();
                var imgWidth = selImg.parents('.img-wrapper').find('img').width();
                var captionText = selImg.parents('.img-wrapper').find('.caption').html();
                _private.openImageOverlayWithProperties(imgSrc, imgHeight, imgWidth, captionText);

            });
        }
    };
    
    var public = {
        initImageOverlay : _private.initImageOverlay,
        interceptLinkTaps : _private.interceptLinkTaps,
        openImageOverlayWithProperties : _private.openImageOverlayWithProperties
    };
    
    return public;
}