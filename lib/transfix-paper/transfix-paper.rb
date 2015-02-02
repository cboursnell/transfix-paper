require 'fileutils'
require 'yaml'

module TransfixPaper

  class Paper

    def initialize
      @gem_dir = Gem.loaded_specs['transfix-paper'].full_gem_path
      @yaml = "data.yaml"
      @threads = 24
    end

    # Chimera simulation
    #  - simulate reads from reference transcriptome
    #  - select transcripts randomly and join them together
    #  - run transrate and then transfix on the new assembly
    #  - show that the errors are detected and fixed

    # Fragmentation simulation 1
    #  - download reads
    #  - align against a reference
    #  - run salmon to find which transcripts are expressed
    #  - choose random transcripts from that set and split them
    #  - show that the fragmented transcripts are detected and scaffolded

    def fragmentation
      # download reads and reference to gem_dir/reads and gem_dir/reference
      @data = YAML.load_file @yaml
      download
      @data.each do |species, species_data|
        path = File.join(@gem_dir, "data", species.to_s, "fragmentation")

        # make directory for fragmentation analysis in gem_dir/data
        FileUtils.mkdir_p(path) unless Dir.exist?(path)
        Dir.chdir(path) do
          puts "changing to #{path}"
          left = species_data[:reads][:left].collect do |fastq|
            File.join(@gem_dir, "data", species.to_s, "reads", fastq)
          end.join(',')
          right = species_data[:reads][:right].collect do |fastq|
            File.join(@gem_dir, "data", species.to_s, "reads", fastq)
          end.join(',')
          reference = File.join(@gem_dir, "data", species.to_s, "transcriptome",
            species_data[:transcriptome][:fa])

          # align (snap) reads to reference
          snap = Snap.new
          bam = snap.run(left, right, reference, @threads)

          # quantify expression (salmon)
          salmon = Salmon.new
          assigned_bam = salmon.run(reference, bam, @threads)

          # load expression quantification output
          # choose X transcripts that have expression over Y
          quant = "quant.sf"
          expression = {}
          File.open(quant).each do |line|
            if line !~ /^#/
              cols = line.chomp.split("\t")
              length = cols[1].to_i
              tpm = cols[2].to_f
              reads = cols[4].to_i
              if length > 600 and (reads/length.to_f > 1)
                expression[cols[0]] = { :length => length,
                                        :tpm => tpm,
                                        :reads => reads }
              end
            end
          end
          puts "fragmentable contigs: #{expression.length}"
        end
      end


      # break those transcripts in half and make a new fasta file
      # make gem_dir/data/fragmentation/transrate directory
      # transrate with the reads and the new fasta file
      # look at the 'in bridges' number for the known fragmented transcripts
      # run transfix with scaffolding option
    end

    # Fragmentation simulation 2
    #  - simulate paired reads from the reference transcriptome
    #  - select transcripts randomly and break them into pieces
    #  - run transrate and then transfix on the new assembly
    #  - show that the fragmented transcripts are detected and scaffolded

    # Gene Family collapse simulation
    #  - simulated paired reads from the reference transcriptome
    #  - cluster transcripts from the reference with cd-hit-est to merge
    #    similar transcripts into a single contig
    #  - run transrate and then transfix on the new assembly
    #  - show that the contigs that were collapsed have high `p_good`,
    #    `p_bases_covered`, `p_not_segmented`, but low `p_seq_true`
    #  - show that transfix can pull apart the collapsed transcripts

    # Download files specified in data.yaml
    def download
      @data.each do |species, species_data|
        species_data.each do |key, value|
          if [:reads, :transcriptome].include? key
            output_dir = File.join(@gem_dir, "data", species.to_s, key.to_s)
            FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)
            value.each do |desc, paths|
              if desc == :url
                paths = [paths] unless paths.is_a?(Array)
                paths.each do |url|
                  Dir.chdir(output_dir) do
                    dl = Downloader.new(url)
                    dl.run
                  end
                end
              end
            end
          end
        end
      end
    end

  end

end
