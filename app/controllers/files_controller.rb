class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    @file.purge if @file.record.author_id == current_user.id
  end
end
