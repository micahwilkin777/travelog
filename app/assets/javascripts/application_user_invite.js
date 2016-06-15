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


//= require lib/formValidation.min
//= require lib/formValidation_bootstrap.min

//= require lib/sample-04/custom
//= require lib/common-files/modernizr.custom.js
//= require lib/common-files/startup-kit.js
//= require lib/sample-04/script.js

//= require common.js

function stickDropdown(_elem){
  $(_elem).parent().removeClass('open').addClass('open');
}