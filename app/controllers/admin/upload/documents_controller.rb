class Admin::Upload::DocumentsController < ApplicationController
  # GET /admin/upload/documents
  def index
    @documents = Admin::Upload::Document.all
  end

  # GET /admin/upload/documents/1
  def show
    @document = Admin::Upload::Document.find(params[:id])
  end

  # GET /admin/upload/documents/new
  def new
    @document = Admin::Upload::Document.new
  end

  # POST /admin/upload/documents
  def create
    @admin_upload_document = Admin::Upload::Document.new(params[:admin_upload_document])

    if @admin_upload_document.save
      redirect_to(@admin_upload_document, :notice => 'Document was successfully created.') 
    else
      render :action => "new" 
    end
  end

  # DELETE /admin/upload/documents/1
  def destroy
    @admin_upload_document = Admin::Upload::Document.find(params[:id])
    @admin_upload_document.destroy

    redirect_to(admin_upload_documents_url)
  end
end
