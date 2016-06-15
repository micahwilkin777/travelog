class CommentsController < ApplicationController

	def create_comment
		comment = Comment.new(:invoice_id => params[:invoice_id], :user_id => current_user.id, :content => params[:content])
		@invoice = Invoice.find_by_id(params[:invoice_id])
		return render json: {'state': 'failed'}, status: 401 if @invoice.blank?
		if comment.save
			# render json: {'state': 'success'}, status: 200
			render :layout => false, :template => 'invoices/comment_history'
		else
			render json: {'state': 'failed'}, status: 401
		end
	end

	def remove_comment
		comment = Comment.find_by_id(params[:comment_id])
		@invoice = comment.invoice
		if comment.present? && comment.delete
			# render json: {'state': 'success'}, status: 200
			render :layout => false, :template => 'invoices/comment_history'
		else
			render json: {'state': 'failed'}, status: 401
		end
	end

	def update_comment
		comment = Comment.find_by_id(params[:comment_id])
		@invoice = comment.invoice
		comment.content = params[:content]
		if comment.present? && comment.save
			# render json: {'state': 'success'}, status: 200
			render :layout => false, :template => 'invoices/comment_history'
		else
			render json: {'state': 'failed'}, status: 401
		end
	end
	
end