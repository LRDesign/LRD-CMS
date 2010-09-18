class Admin::Upload::ImagesController < ApplicationController
  # GET /admin/upload/images
  def index
    @images = Admin::Upload::Image.all
  end

  # GET /admin/upload/images/1
  def show
    @image = Admin::Upload::Image.find(params[:id])
  end

  # GET /admin/upload/images/new
  def new
    @image = Admin::Upload::Image.new
  end

  # POST /admin/upload/images
  def create
    @admin_upload_image = Admin::Upload::Image.new(params[:admin_upload_image])

    if @admin_upload_image.save
      redirect_to(@admin_upload_image, :notice => 'Image was successfully created.') 
    else
      render :action => "new" 
    end
  end

  # DELETE /admin/upload/images/1
  def destroy
    @admin_upload_image = Admin::Upload::Image.find(params[:id])
    @admin_upload_image.destroy

    redirect_to(admin_upload_images_url)
  end
end
