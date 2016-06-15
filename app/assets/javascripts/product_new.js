$(window).load(function() {
	$(document).ready(function() {

		$('body').loading({
		  stoppable: true
		});

		var adjustProductAttachments = function() {
			$('.attachments-container .clearfix').remove();
			index = 0;
			$('.attachments-container .col-md-4').each(function() {
				index++;
				if (index % 3 == 0) {
					$(this).after('<div class="clearfix"></div>');
				};
			})
		}

		var updateCurrencySymbol = function() {
			switch($('#product_currency').val()) {
				case 'USD':
					$('.input-group-addon.currency-symbol').text('$');
					break;
				case 'MYR':
					$('.input-group-addon.currency-symbol').text('RM');
					break;
				case 'SGD':
					$('.input-group-addon.currency-symbol').text('$');
					break;
				case 'THB':
					$('.input-group-addon.currency-symbol').text('฿');
					break;
				case 'PHP':
					$('.input-group-addon.currency-symbol').text('$');
					break;
				case 'TWD':
					$('.input-group-addon.currency-symbol').text('NT$');
					break;
			}
		}

		var showRefundableFields = function() {

			$option_refund_day   = $('form').find('[name="product[refund_day]"]');
	    $option_refund_percent   = $('form').find('[name="product[refund_percent]"]');

			if ($('#product_refundable').prop('checked')) {
				$('.refund-area').css('display', 'block');
				
	      $('form').formValidation('revalidateField', 'product[refund_day]');
				$('form').formValidation('revalidateField', 'product[refund_percent]');
			} else {

				$('form').formValidation('revalidateField', 'product[refund_day]');
				$('form').formValidation('revalidateField', 'product[refund_percent]');
				
				$('.refund-area').css('display', 'none');
				
			}
		}

		$('#product_description').froalaEditor()
		.on('froalaEditor.contentChanged', function() {
      $('form').formValidation('revalidateField', 'product[description]');
    });

		$('#product_highlight').froalaEditor()
		.on('froalaEditor.contentChanged', function() {
      $('form').formValidation('revalidateField', 'product[highlight]');
    });

		$('textarea').css({'display': 'block', 'opacity': '0', 'height': '0px'});

		// $('select').selectpicker({
		// 	liveSearch: false,
		// 	maxOptions: 1
		// });
		// adjustProductAttachments();
		// showRefundableFields();
		updateCurrencySymbol();

		$(document).on('change', '#product_refundable', function() {
			showRefundableFields();
		})

		
		$(document).on('click', '#add-photo-button', function() {
			attachment_count = $('.attachments-container .col-md-4').length
			if (attachment_count < 5) {
				$('#file_upload').trigger('click');
			} else {
				alert("Can't upload more than 5.");
			}
			
		})

		$('.photos-section').on('change', '#file_upload', function() {
			var photo_count = $('.photo-item.upload-photo-frame').length
			if (photo_count >= 5) {
				alert("Can't upload more than 5.");
				return false;
			};
			$('body').loading({});

			var formData = new FormData();
			formData.append('product_attachment[attachment]', this.files[0]);
			$.ajax({
			  url: '/product_attachments',
			  dataType: "json",
			  data: formData,
			  cache: false,
			  contentType: false,
			  processData: false,
			  type: 'POST',
			  success: function(data) {
			  	console.log('success');
			  	
			  	$empty_photo = $($('.empty-photo-frame.photo-item')[0]);
			  	$clone = $empty_photo.parent().clone();
			  	$empty_photo.removeClass('empty-photo-frame').addClass('upload-photo-frame').append('<input type="hidden" name="product_attachment[id][]" value="' + data.id + '">');
			  	$empty_photo.append('<button type="button" class="btn btn-default delete-attachment">Delete</button>');
			  	$empty_photo.find('img').attr({'src': data.attachment.small.url, 'data-id': data.id });

			  	$empty_photo.find('i').remove();
			  	$empty_photo.find('small').remove();
			  	$clone.find('i').remove();
			  	$clone.find('small').remove();

					$('.attachments-container').append($clone);
					$('#file_upload').val('');

					$('form').formValidation('revalidateField', 'empty-photo-frame');
			  	$('body').loading('stop');
			  	

			  },
			  error: function(error) {
	      	console.log(error);
	      	$('body').loading('stop');
	      },
	      timeout: 100000
			});

		})

		$('.attachments-container').on('click', '.delete-attachment', function(event) {
			$(this).parent().fadeOut('slow', function() {
				$(this).remove();
			});
			var attachment_id = $(this).parent().find('input[name="product_attachment[id][]"]').val();
			$.ajax({
			  type: "POST",
        url: "/product_attachments/" + attachment_id,
        dataType: "json",
        data: { "_method": "delete" },
        complete: function(){
          console.log('deleted attachment');
        }
			});
			event.preventDefault();

		})

		$('.photo-submit.btn').on('click', function(e) {
			
			
		})

		// change currency symbol
		$(document).on('change', '#product_currency', function() {
			updateCurrencySymbol();
		})

		$('form').formValidation({
			framework: 'bootstrap',
			icon: {
				valid: 'glyphicon glyphicon-ok',
				invalid: 'glyphicon glyphicon-remove',
				validating: 'glyphicon glyphicon-refresh'
			},
			fields: {
				'product[name]': {
					row: '.col-xs-12',
					validators: {
						notEmpty: {
							message: 'The product name is required'
						}
					}
				},
				'product[city]': {
					row: '.col-xs-12',
					validators: {
						notEmpty: {
							message: 'The city is required'
						}
					}
				},
				'product[state]': {
					row: '.col-xs-12',
					validators: {
						notEmpty: {
							message: 'The state is required'
						}
					}
				},
				'product[description]': {
					row: '.col-xs-12',
					validators: {
						callback: {
              message: 'The description is required and cannot be empty',
              callback: function(value, validator, $field) {
                var code = $('[name="product[description]"]').val();
                // <p><br></p> is code generated by Summernote for empty content
                return (code !== '' && code !== '<p><br></p>');
              }
            }
					}
				},
				'product[highlight]': {
					row: '.col-xs-12',
					validators: {
						callback: {
              message: 'The highlight is required and cannot be empty',
              callback: function(value, validator, $field) {
                var code = $('[name="product[highlight]"]').val();
                // <p><br></p> is code generated by Summernote for empty content
                return (code !== '' && code !== '<p><br></p>');
              }
            }
					}
				},
				'product[refund_day]': {
					row: '.col-xs-12',
					validators: {
						callback: {
							message: 'The refund day is required',
							callback: function(value, validator, $field) {
								var code = $('[name="product[refund_day]"]').val();
								return (!$('#product_refundable').prop('checked') || code !== '');
							}
						}
					}
				},
				'product[refund_percent]': {
					row: '.col-xs-12',
					validators: {
						callback: {
							message: 'The refund day is required',
							callback: function(value, validator, $field) {
								var code = $('[name="product[refund_percent]"]').val();
								return (!$('#product_refundable').prop('checked') || code !== '');
							}
						}
					}
				},
				'product[price_cents]': {
					row: '.col-xs-12',
					validators: {
						callback: {
							message: 'The base price is required',
							callback: function(value, validator, $field) {
								var code = $('[name="product[price_cents]"]').val();
								var variant_count = $('.variants-container.form-group > .form-group').length;
								return (variant_count > 1 || code !== '');
							}
						}
					}
				},
				'product[discount]': {
					row: '.col-xs-12',
					validators: {
						notEmpty: {
							message: 'The discount is required'
						}
					}
				},
				'variant[][name]': {
					row: '.col-xs-12',
					validators: {
						notEmpty: {
							message: 'The variant name is required'
						}
					}
				},
				'variant[][price_cents]': {
					row: '.col-xs-12',
					validators: {
						notEmpty: {
							message: 'The variant price is required'
						}
					}
				},
				'empty-photo-frame': {
					row: '.col-xs-12',
					validators: {
						callback: {
							message: 'The photo is required',
							callback: function(value, validator, $field) {
								var photo_count = $('.attachments-container .upload-photo-frame').length;
								return (photo_count > 0)
							}
						}
					}
				}
			}
		})
		.on('click', '#add-variant-button', function() {
	
			var $template = $('#variantTemplate');
			$clone = $template.clone().removeClass('hide').removeAttr('id');
      $('.variants-container').append($clone);
      $option_name   = $clone.find('[name="variant[][name]"]');
      $option_price_cents   = $clone.find('[name="variant[][price_cents]"]');

      // Add new field
      $('form').formValidation('addField', $option_name);
      $('form').formValidation('addField', $option_price_cents);

      // revalidate the price cents field
      $('form').formValidation('revalidateField', 'product[price_cents]');

      $('form').find('[name="product[price_cents]"]').prop('disabled', true);
			
		})
		.on('click', '.removeButton', function() {
			var $row    = $(this).closest('.form-group');
      $option_name   = $row.find('[name="variant[][name]"]');
      $option_price_cents   = $row.find('[name="variant[][price_cents]"]');

      
      // Remove field
      $('form').formValidation('removeField', $option_name);
      $('form').formValidation('removeField', $option_price_cents);

      // Remove element containing the option
      $row.remove();

      var count_variants = $('form .variants-container > .form-group').length - 1;
      if(count_variants == 0) {
      	$('form').find('[name="product[price_cents]"]').prop('disabled', false);
      }

		})

	 

		showRefundableFields();

		$('body').loading('stop');

	});

});




