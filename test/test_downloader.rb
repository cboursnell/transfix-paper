require 'helper'
require 'tmpdir'

class TestDownloader < Test::Unit::TestCase

  context "Downloader" do

    setup do
    end

    teardown do
    end

    should "download and unpack a file" do
      url = "https://raw.githubusercontent.com/Blahah/bindeps/master/test/data/fakebin.tgz"
      file = "fakebin"
      dl = TransfixPaper::Downloader.new(url, file)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do |dir|
          dl.run
          assert File.exist?(file)
        end
      end
    end

    should "download a file that doesn't need unpacking" do
      url = "https://raw.githubusercontent.com/Blahah/bindeps/master/test/data/fakebin4"
      file = "fakebin4"
      dl = TransfixPaper::Downloader.new(url, file)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do |dir|
          dl.run
          assert File.exist?(file)
        end
      end
    end

    should "not redownload a file that is already there" do
      url = "https://raw.githubusercontent.com/Blahah/bindeps/master/test/data/fakebin.tgz"
      file = "fakebin"
      dl = TransfixPaper::Downloader.new(url, file)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do |dir|
          `wget #{url}` # download it first
          dl.run
          assert File.exist?(file)
        end
      end

    end

    should "fail on bad url" do
      url = "https://raw.githubusercontent.com/Blahah/bindeps/master/test/data/badurlblah.tgz"
      file = "fakebin"
      dl = TransfixPaper::Downloader.new(url, file)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do |dir|
          # assert_raise RuntimeError do
          assert_equal false, dl.run
          # end
        end
      end
    end

    should "fail on misnamed archive" do
      url = "https://raw.usercontent.com/data/archive.gz"
      file = "archive"
      dl = TransfixPaper::Downloader.new(url, file)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do |dir|
          gem_dir = Gem.loaded_specs['transfix-paper'].full_gem_path
          cmd = "cp #{gem_dir}/test/data/archive.bz2 #{tmpdir}/archive.gz"
          `#{cmd}`
          assert_raise RuntimeError do
            dl.run
          end
        end
      end
    end

  end
end
