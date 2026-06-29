# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: %i[edit update]

  def index
    @pages = Page.order(:title, :created_at)
    @workspace = current_workspace
  end

  def new
    @page = Page.new
  end

  def create
    @page = nil
    current_root_recording.record(Page, actor: current_user) do |page|
      page.assign_attributes(page_params)
      @page = page
    end

    redirect_to pages_path, notice: "Page created successfully."
  rescue ActiveRecord::RecordInvalid
    @page ||= Page.new(page_params)
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to pages_path, notice: "Page updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :site_colour)
  end

  def current_workspace
    recordable = current_root_recordable
    return recordable if recordable.is_a?(Workspace)

    Workspace.order(:name).first!
  end

  def current_root_recording
    RecordingStudio.root_recording_for(current_workspace)
  end
end
