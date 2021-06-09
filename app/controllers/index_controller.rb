class IndexController < ApplicationController
  ROOT_DIR = ENV['ROOT_DIR'] || '.'

  def index
    @directory = Dir.entries(ROOT_DIR)
    @path = ''
    @root_path = ROOT_DIR
  end

  def path
    check_path

    if File.directory?(@root_path)
      @directory = Dir.entries(@root_path)
      @path = "#{params[:path]}/"
      render :index
    elsif File.file?(@root_path)
      if File.size(@root_path) > 250_000
        send_file @root_path
      else
        @file = File.read(@root_path)
        render :file
      end
    end
  end

  private

  def check_path
    current_directory = File.expand_path(ROOT_DIR)
    @root_path = File.expand_path(params[:path], ROOT_DIR)
    raise ActionController::RoutingError, 'Not Found' unless File.exists?(@root_path)

    unless @root_path.starts_with?(current_directory)
      raise ArgumentError, 'Should not be parent of root'
    end
  end
end
