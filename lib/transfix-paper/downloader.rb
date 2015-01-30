
require 'fixwhich'

module TransfixPaper

  # downloads necessary data

  class Downloader

    def initialize(url, file)
      @file = file
      @url = url
      @curl = Which::which('curl').first
      @wget = Which::which('wget').first
      if !@curl and !@wget
        msg = "Don't know how to download files without curl or wget installed"
        raise RuntimeError.new(msg)
      end
    end

    def run
      if !File.exist?(@file)
        target = File.basename(@url)
        if !File.exist?(target)
          if !download
            return false
          end
        end
        if !extract(target)
          raise RuntimeError.new("extracting failed")
        end
      end
      return true
    end

    def download
      if @wget
        cmd = "wget #{@url} -O #{File.basename(@url)}"
      elsif @curl
        cmd = "curl #{@url} -o #{File.basename(@url)}"
      else
        raise RuntimeError.new("Neither curl or wget installed")
      end
      stdout, stderr, status = Open3.capture3 cmd
      if !status.success?
        puts "Download failed\n#{@url}\n#{stdout}\n#{stderr}\n"
        return false
      end
      return true
    end

    def extract(name)
      # puts "extract: name: #{name}"
      if name =~ /\.tar\.gz$/ or name =~ /\.tgz/
        cmd = "tar xzf #{name}"
      elsif name =~ /\.gz$/
        cmd = "gunzip #{name}"
      elsif name =~ /\.zip$/
        cmd = "unzip #{name}"
      elsif name =~ /\.sra$/
        cmd = "fastq-dump.2.3.5.2 --origfmt --split-3 #{name} --outdir #{output_dir}"
      else
        cmd = "echo extracted"
      end
      # puts "extract cmd: #{cmd}"
      stdout, stderr, status = Open3.capture3 cmd
      return status.success?
    end

  end

end