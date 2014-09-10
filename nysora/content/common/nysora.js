$(function() {
    
    //Attach fastclick
    FastClick.attach(document.body);

    //Set the swf replacement (even though ios can't handle swf, video-js malfunctions if this path isnt set)
    videojs.options.flash.swf = "content/common/video-js.swf";


    var nysora = initNysora();
    nysora.initImageOverlay();
    nysora.interceptLinkTaps();
    //nysora.initGestureRecognizers();

});

function initNysora() {
    var _private = {
        initImageOverlay : function() {
            $('.img-wrapper').on('click', function(e) {
                window.location = 'nysora://gallery/?' + $(e.target).parents('.img-wrapper').attr('name');
                /*if(!$('.content').hasClass('active')) {
                    //Get img properties
                    var imgSrc = $(e.target).parents('.img-wrapper').find('img').attr('src');
                    var imgHeight =  $(e.target).parents('.img-wrapper').find('img').height();
                    var imgWidth = $(e.target).parents('.img-wrapper').find('img').width();
                    var captionText = $(e.target).parents('.img-wrapper').find('.caption').html();
                    _private.openImageOverlayWithProperties(imgSrc, imgHeight, imgWidth, captionText);
                }*/
            });
        },
        initGestureRecognizers : function () {
            window.location = "nysora://inited/";
            var hammertime = new Hammer(document.body);
            hammertime.on('swipeleft', function(ev) {
                window.location = "nysora://swipeleft/";
            });
            hammertime.on('swiperight', function(ev) {
                window.location = "nysora://swiperight";
            })
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
            });
        }
    };
    
    var public = {
        initImageOverlay : _private.initImageOverlay,
        interceptLinkTaps : _private.interceptLinkTaps,
        initGestureRecognizers : _private.initGestureRecognizers
    };
    
    return public;
}