class IndexController < ApplicationController
  ROOT_DIR = ENV['ROOT_DIR'] || '.'

  def index
    @directory = Dir.entries(ROOT_DIR)
    @path = ''
    @current_path = ROOT_DIR
  end

  def path
    check_path

    if File.directory?(@current_path)
      @directory = Dir.entries(@current_path)
      @path = "#{params[:path]}/"
      render :index
    elsif File.file?(@current_path)
      if File.size(@current_path) > 250_000
        send_file @current_path
      else
        @file = File.read(@current_path)
        render :file
      end
    end
  end

  private

  def check_path
    current_directory = File.expand_path(ROOT_DIR)
    @current_path = File.expand_path(params[:path], ROOT_DIR)
    raise ActionController::RoutingError, 'Not Found' unless File.exists?(@current_path)

    unless @current_path.starts_with?(current_directory)
      raise ArgumentError, 'Should not be parent of root'
    end
  end
end
