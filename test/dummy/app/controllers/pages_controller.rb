# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: %i[edit update destroy]

  def index
    @pages = current_root_recording
      .recordings_of(Page)
      .includes(:recordable)
      .map(&:recordable)
      .sort_by { |page| [page.title.to_s.downcase, page.created_at || Time.at(0)] }
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
    recording = page_recording_for(@page)
    if recording
      root_recording_for(recording).revise(recording, actor: current_user, metadata: { source: "ui" }) do |page|
        page.assign_attributes(page_params)
      end
    else
      # Legacy/unrecorded rows can still exist in dummy data; update directly.
      Page.unscoped.where(id: @page.id).update_all(page_params.to_h.merge(updated_at: Time.current))
    end

    redirect_to pages_path, notice: "Page updated successfully."
  rescue ActiveRecord::RecordInvalid => error
    @page = error.record
    render :edit, status: :unprocessable_entity
  end

  def destroy
    recording = page_recording_for(@page)
    if recording
      recording.trash!
    else
      # Legacy/unrecorded rows can still exist in dummy data; delete directly.
      Page.unscoped.where(id: @page.id).delete_all
    end

    redirect_to pages_path, notice: "Page deleted successfully."
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :site_colour, site_publications: [])
  end

  def current_workspace
    recordable = current_root_recordable
    return recordable if recordable.is_a?(Workspace)

    Workspace.order(:name).first!
  end

  def current_root_recording
    RecordingStudio.root_recording_for(current_workspace)
  end

  def page_recording_for(page)
    RecordingStudio::Recording.unscoped.find_by(recordable_type: page.class.name, recordable_id: page.id) ||
      RecordingStudio::Recording.unscoped
        .joins(:events)
        .where(recording_studio_events: {
                 recordable_type: page.class.name,
                 recordable_id: page.id
               })
        .or(
          RecordingStudio::Recording.unscoped
            .joins(:events)
            .where(recording_studio_events: {
                     previous_recordable_type: page.class.name,
                     previous_recordable_id: page.id
                   })
        )
        .order(updated_at: :desc)
        .first
  end

  def root_recording_for(recording)
    recording.root_recording || recording
  end
end
