class ArController < ApplicationController
  before_action :authenticate_user!

  def new
    @tattoo_photo = params[:tattoo_url]
    @message_feed = MessageFeed.find(params[:message_feed_id])

    @hide_navbar = true
  end

  def create
    data_url = params[:photo][:data]
    tattoo_url = ActiveStorage::Attachment.find(params[:photo][:tattoo_url])
    if data_url.present?
      image_data = split_base64(data_url)
      io = StringIO.new(Base64.decode64(image_data[:data]))
      io.class.class_eval { attr_accessor :original_filename, :content_type }
      io.original_filename = "photo-#{Time.now.to_i}.png"
      io.content_type = image_data[:type]
      current_user.ar_photo.attach(io: io, filename: io.original_filename, content_type: io.content_type)
      redirect_to show_ar_path(tattoo_url: tattoo_url)
    else
      redirect_to new_photo_path, alert: "Aucune photo reçue."
    end
  end
  def show
    @hide_navbar = true
    @user = current_user
    @tattoo_url = ActiveStorage::Attachment.find(params[:tattoo_url])
  end

  private

  def split_base64(uri_str)
    if uri_str =~ /^data:(.*?);(.*?),(.*)$/
      {
        type:      $1,
        encoder:   $2,
        data:      $3,
        extension: $1.split('/')[1]
      }
    end
  end
end
