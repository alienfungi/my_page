class CommentMailer < ActionMailer::Base
  default from: "commentMailer@zanewoodfin.com"

  def comment_email(comment)
  	# add throw error statement if comment object invalid
  	@comment = comment
  	mail to: 'Zane Woodfin <zanewoodfin@gmail.com>',
  			 subject: "A comment from zanewoodfin.com has arrived"
  end
end
