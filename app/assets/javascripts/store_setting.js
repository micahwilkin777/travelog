! function() {
  $.fn.stepsForm = function(t) {
    var e = {
        width: '100%',
        active: 0,
        errormsg: 'Check faulty fields.',
        sendbtntext: 'Create Account',
        posturl: '/complete_merchant',
        theme: 'default'
      },
      t = $.extend(e, t);
    return this.each(function() {
      function e(e) {
        for (requredcontrol = !1, i = 0; i < e; i++)
          f.find('.sf-steps-form>ul').eq(i).find(':input').each(function() {
            $(this).parent().find('.error').remove();
            if ('true' == $(this).attr('data-required')) {
              
              if ('' == $(this).val().trim()) {
                $(this).addClass('sf-error');
                $(this).parent().append('<label class="error">' + $(this).prop('placeholder') + ' can\'t be blank</label>');
                requredcontrol = !0;  
              } else if ($(this).val().trim().length < 2) {
                $(this).addClass('sf-error');
                $(this).parent().append('<label class="error">' + $(this).prop('placeholder') + ' is too short (minimum is 2 characters)</label>');
                requredcontrol = !0;
              }
            } else {
              'true' != $(this).attr('data-required') || 'radio' != $(this).attr('type') && 'checkbox' != $(this).attr('type') ? '' != $(this).val() && ('true' == $(this).attr('data-email') && 0 == r($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-number') && isNaN($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-confirm') && (h.push($(this).val()), u.push($(this)), a())) : 'radio' == $(this).attr('type') ? $(this).parent().parent().find('input[type=\'radio\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0) : $(this).parent().parent().find('input[type=\'checkbox\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0);
            }
          });
        d();
        h.length = 0;
        if (requredcontrol) {
          // f.find('#sf-msg').html(t.errormsg);
        } else {
          if ($('#temp_sharing_url').length > 0) {
            console.log('aaa');
            var arr = f.find('form').serializeArray();
            $.ajax({
              url: "/forms/get_slug.json",
              type: "POST",
              data: arr,
              dataType:'json',
              timeout: 20000,
              success: function(data) {
                console.log('success');
                // console.log(data);
                $('#slug-input').val(data);
                if ($('#form_sharing_url').val() == "") {
                  temp_sharing_url = $('#temp_sharing_url').val();
                  populated_sharing_url = temp_sharing_url.substring(0, temp_sharing_url.length - 4) + data
                  $('#form_sharing_url').val(populated_sharing_url);
                  $('#span-sharing-url').text(populated_sharing_url);
                };
              },
              error: function(data) {
                console.log('error');
                // console.log(data);
              }
              
            })
          };
          
          o();
          u.length = 0;
          t.active = e;
          if (t.active > c - 1) {
            t.active--;
            f.find('#sf-msg').text('');
          } else {
            n();
            requredcontrol = !1;
            f.find('#sf-msg').text('');
          }
        }
      }

      function s() {
        f.width() > 500 ? (f.find('.column_1').css({
          width: '16.666666667%',
          'margin-bottom': '0px'
        }), f.find('.column_2').css({
          width: '33.333333334%',
          'margin-bottom': '0px'
        }), f.find('.column_3').css({
          width: '50%',
          'margin-bottom': '0px'
        }), f.find('.column_4').css({
          width: '66.666666667%',
          'margin-bottom': '0px'
        }), f.find('.column_5').css({
          width: '83.333333334%',
          'margin-bottom': '0px'
        }), f.find('.column_6').css({
          width: '100%',
          'margin-bottom': '0px'
        }), f.find('.sf-content>li').css({
          'margin-bottom': '2rem'
        }), f.find('.sf-steps-content').removeClass('sf-steps-center'), f.find('.sf-steps-navigation').removeClass('sf-align-center').addClass('sf-align-right')) : (f.find('.column_1').css({
          width: '100%',
          'margin-bottom': '2rem'
        }), f.find('.column_2').css({
          width: '100%',
          'margin-bottom': '2rem'
        }), f.find('.column_3').css({
          width: '100%',
          'margin-bottom': '2rem'
        }), f.find('.column_4').css({
          width: '100%',
          'margin-bottom': '2rem'
        }), f.find('.column_5').css({
          width: '100%',
          'margin-bottom': '2rem'
        }), f.find('.column_6').css({
          width: '100%',
          'margin-bottom': '2rem'
        }), f.find('.sf-content>li').css({
          'margin-bottom': '0px'
        }), f.find('.sf-steps-content').addClass('sf-steps-center'), f.find('.sf-steps-navigation').removeClass('sf-align-right').addClass('sf-align-center'));
      }

      function n() {
        f.find('.sf-steps-content>div').removeClass('sf-active'), f.find('.sf-steps-form>.sf-content').css({
          display: 'none'
        }), f.find('.sf-steps-form>ul').eq(t.active).fadeIn(), f.find('.sf-steps-content>div').eq(t.active).addClass('sf-active'), 
        f.find('#sf-next').text(t.active == c - 1 ? t.sendbtntext : l), 
        f.find('#sf-prev').css(0 == t.active ? {
          display: 'none'
        } : {
          display: 'inline-block'
        }), f.find('#sf-next1').css(c - 1 == t.active ? {
          display: 'none'
        } : {
          display: 'inline-block'
        });
      }

      function r(t) {
        var e = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return e.test(t);
      }

      function a() {
        var t = h[0];
        for (index = 0; index < h.length; index++)
          h[index] != t && (requredcontrol = !0), fisrctval = h[index];
      }

      function d() {
        for (index = 0; index < u.length; index++)
          u[index].addClass('sf-error');
      }

      function o() {
        for (index = 0; index < u.length; index++)
          u[index].removeClass('sf-error');
      }
      var f = $(this),
        c = f.find('.sf-steps-content').find('div').length,
        l = f.find('#sf-next').text(),
        h = new Array(),
        u = new Array();
      f.css({
        width: t.width
      });
      f.addClass('sf-theme-' + t.theme), n(), f.find(':input').on('click', function() {
        var t = $(this).parent().parent().find('input').attr('type');
        'radio' == t || 'checkbox' == t ? $(this).parent().parent().find('input').removeClass('sf-error') : $(this).removeClass('sf-error');
      });
      f.find('.sf-steps-content>div').on('click', function() {
        // 'sf-active' != $(this).attr('class') && (t.active > $(this).index() ? (t.active = $(this).index(), n()) : e($(this).index()));

        // if ('sf-active' != $(this).attr('class') && t.active > $(this).index()) {
        //   t.active = $(this).index();
        //   n();
        // } else {
        //   e($(this).index());
        // }
      });
      f.find('#sf-next').on('click', function() {
        requredcontrol = !1; 
        f.find('.sf-steps-form>ul').eq(t.active).find(':input').each(function() {
          // 'true' == $(this).attr('data-required') && '' == $(this).val() ? ($(this).addClass('sf-error'), requredcontrol = !0) : 'true' != $(this).attr('data-required') || 'radio' != $(this).attr('type') && 'checkbox' != $(this).attr('type') ? '' != $(this).val() && ('true' == $(this).attr('data-email') && 0 == r($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-number') && isNaN($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-confirm') && (h.push($(this).val()), u.push($(this)), a())) : 'radio' == $(this).attr('type') ? $(this).parent().parent().find('input[type=\'radio\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0) : $(this).parent().parent().find('input[type=\'checkbox\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0);
          $(this).parent().find('.error').remove();
          if ('true' == $(this).attr('data-required')) {
            if ('' == $(this).val().trim()) {
              $(this).addClass('sf-error');
              $(this).parent().append('<label class="error">' + $(this).prop('placeholder') + ' can\'t be blank</label>');
              requredcontrol = !0;
            } else if ($(this).val().trim().length < 2) {
              $(this).addClass('sf-error');
              $(this).parent().append('<label class="error">' + $(this).prop('placeholder') + ' is too short (minimum is 2 characters)</label>');
              requredcontrol = !0;
            };
            
          } else {
            'true' != $(this).attr('data-required') || 'radio' != $(this).attr('type') && 'checkbox' != $(this).attr('type') ? '' != $(this).val() && ('true' == $(this).attr('data-email') && 0 == r($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-number') && isNaN($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-confirm') && (h.push($(this).val()), u.push($(this)), a())) : 'radio' == $(this).attr('type') ? $(this).parent().parent().find('input[type=\'radio\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0) : $(this).parent().parent().find('input[type=\'checkbox\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0);
          }
        });
        d();
        h.length = 0;

        // validate for store user name
        if (!requredcontrol) {
          if ($('input[name="store_setting[store_username]"]').is(':visible')) {
            
            $store_username = $('input[name="store_setting[store_username]"]');
            $store_username.parent().find('label.error').remove();
            $.ajax({
              type: "GET",
              url: "/users/verify_store_username",
              dataType: "json",
              data: {
                "store_username": $store_username.val()
              },
              success: function(data) {
                console.log(data.result);
                if (!data.result) {
                  requredcontrol = !0;
                  $store_username.parent().append('<label class="error">' + $store_username.prop('placeholder') + ' is not available</label>');
                }
                if (!requredcontrol) {
                  o();
                  u.length = 0;
                  if (f.find('#sf-next').text() == t.sendbtntext) {
                    f.find('form').submit();
                  } else {
                    t.active++;
                    if (t.active > c - 1) {
                      t.active--, f.find('#sf-msg').text('');
                    } else {
                      n(), requredcontrol = !1, f.find('#sf-msg').text('');
                    }
                  }      
                }
              }
            });
          }
          else {
            o();
            u.length = 0;
            if (f.find('#sf-next').text() == t.sendbtntext) {
              f.find('form').submit();
            } else {
              t.active++;
              if (t.active > c - 1) {
                t.active--, f.find('#sf-msg').text('');
              } else {
                n(), requredcontrol = !1, f.find('#sf-msg').text('');
              }
            }
          }
        };
        
      });
      
      f.find('#sf-next1').on('click', function() {
        requredcontrol = !1;
        f.find('.sf-steps-form>ul').eq(t.active).find(':input').each(function() {
          // 'true' == $(this).attr('data-required') && '' == $(this).val() ? ($(this).addClass('sf-error'), requredcontrol = !0) : 'true' != $(this).attr('data-required') || 'radio' != $(this).attr('type') && 'checkbox' != $(this).attr('type') ? '' != $(this).val() && ('true' == $(this).attr('data-email') && 0 == r($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-number') && isNaN($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-confirm') && (h.push($(this).val()), u.push($(this)), a())) : 'radio' == $(this).attr('type') ? $(this).parent().parent().find('input[type=\'radio\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0) : $(this).parent().parent().find('input[type=\'checkbox\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0);
          $(this).parent().find('.error').remove();
          if ('true' == $(this).attr('data-required')) {
            if ('' == $(this).val().trim()) {
              $(this).addClass('sf-error');
              $(this).parent().append('<label class="error">' + $(this).prop('placeholder') + ' can\'t be blank</label>');
              requredcontrol = !0;
            } else if ($(this).val().trim().length < 2) {
              $(this).addClass('sf-error');
              $(this).parent().append('<label class="error">' + $(this).prop('placeholder') + ' is too short (minimum is 2 characters)</label>');
              requredcontrol = !0;
            };
            
          } else {
            'true' != $(this).attr('data-required') || 'radio' != $(this).attr('type') && 'checkbox' != $(this).attr('type') ? '' != $(this).val() && ('true' == $(this).attr('data-email') && 0 == r($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-number') && isNaN($(this).val()) && ($(this).addClass('sf-error'), requredcontrol = !0), 'true' == $(this).attr('data-confirm') && (h.push($(this).val()), u.push($(this)), a())) : 'radio' == $(this).attr('type') ? $(this).parent().parent().find('input[type=\'radio\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0) : $(this).parent().parent().find('input[type=\'checkbox\']:checked').length < 1 && ($(this).addClass('sf-error'), requredcontrol = !0);
          }
        });
        d();
        h.length = 0;

        if (requredcontrol) {
          // f.find('#sf-msg').html(t.errormsg)
        } else {
          o();
          u.length = 0;
          t.active++;
          if (t.active > c - 1) {
            t.active--, f.find('#sf-msg').text('');
          } else {
            n(), requredcontrol = !1, f.find('#sf-msg').text('');
          }
        }
      })
      f.find('#sf-prev').on('click', function() {
        t.active--, t.active < 0 ? t.active++ : (n(), requredcontrol = !1);
      });

      s();
      $(window).resize(function() {
        s();
      });
    });
  };
}(jQuery);
$(document).ready(function(e) {
  $('.stepsForm').stepsForm({
    width: '100%',
    active: 0,
    errormsg: 'Check faulty fields.',
    sendbtntext: 'Complete',
    posturl: '/complete_merchant',
    theme: 'blue'
  });
  $('.container .themes>span').click(function(e) {
    $('.container .themes>span').removeClass('selectedx');
    $(this).addClass('selectedx');
    $('.stepsForm').removeClass().addClass('stepsForm');
    $('.stepsForm').addClass('sf-theme-' + $(this).attr('data-value'));
  });
});