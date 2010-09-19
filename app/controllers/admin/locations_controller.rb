class Admin::LocationsController < ApplicationController
  # GET /locations
  def index
    @locations = Location.all
  end

  # GET /locations/1
  def show
    @location = Location.find(params[:id])
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    @location = Location.new(params[:location])

    if @location.save
      redirect_to(admin_location_path(@location), :notice => 'Location was successfully created.') 
    else
      render :action => "new" 
    end
  end

  # PUT /locations/1
  def update
    @location = Location.find(params[:id])

    if @location.update_attributes(params[:location])
      redirect_to(admin_location_path(@location), :notice => 'Location was successfully updated.')
    else
      render :action => "edit" 
    end
  end

  # DELETE /locations/1
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    redirect_to(admin_locations_url)
  end
end
