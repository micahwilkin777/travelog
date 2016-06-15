// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require froala_editor.min

//= require plugins/align.min.js
//= require plugins/char_counter.min.js
//= require plugins/code_beautifier.min.js
//= require plugins/code_view.min.js
//= require plugins/colors.min.js
//= require plugins/emoticons.min.js
//= require plugins/entities.min.js
//= require plugins/file.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/fullscreen.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/inline_style.min.js
//= require plugins/line_breaker.min.js
//= require plugins/link.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_format.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/quote.min.js
//= require plugins/save.min.js
//= require plugins/table.min.js
//= require plugins/url.min.js
//= require plugins/video.min.js


//= require lib/formValidation.min
//= require lib/formValidation_bootstrap.min
//= require lib/nouislider.min
//= require lib/owlcarousel
//= require lib/loading
//= require lib/bootstrap-datepicker/bootstrap-datepicker.min
//= require jquery.mockjax
//= require bootstrap-typeahead

//= require lib/sample-04/custom.js

//= require lib/common-files/modernizr.custom.js
//= require lib/common-files/startup-kit.js

//= require lib/sample-04/jquery.backgroundvideo.min.js
//= require lib/sample-04/script.js

//= require common.js

function stickDropdown(_elem){
  $(_elem).parent().removeClass('open').addClass('open');
}