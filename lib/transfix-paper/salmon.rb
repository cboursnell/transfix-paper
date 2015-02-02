module TransfixPaper

  class SalmonError < StandardError
  end

  class Salmon

    attr_accessor :quant_output

    def initialize
      which = Cmd.new('which salmon')
      which.run
      if !which.status.success?
        raise SalmonError.new("could not find salmon in the path")
      end
      @salmon = which.stdout.split("\n").first
    end

    def run assembly, bamfile, threads=8
      output = "quant.sf"
      @quant_output = "#{File.basename assembly}_#{output}"
      unless File.exist? @quant_output
        salmon = Cmd.new build_command(assembly, bamfile, threads)
        salmon.run
        unless salmon.status.success?
          logger.error salmon.stderr
          raise SalmonError.new("Salmon failed")
        end
        File.rename(output, @quant_output)
      end
      return 'postSample.bam'
    end

    def build_command assembly, bamfile, threads=8
      cmd = "#{@salmon} --no-version-check quant"
      cmd << " --libType IU"
      cmd << " --alignments #{bamfile}"
      cmd << " --targets #{assembly}"
      cmd << " --threads #{threads}"
      cmd << " --useReadCompat"
      cmd << " --sampleOut"
      cmd << " --sampleUnaligned" # thanks Rob!
      cmd << " --output ."
      cmd
    end

    def load_expression file
      expression = {}
      File.open(file).each do |line|
        if line !~ /^#/
          line = line.chomp.split("\t")
          target = line[0]
          effective_length = line[1]
          effective_count = line[4]
          tpm = line[2]
          expression[target] = {
            :eff_len => effective_length.to_i,
            :eff_count => effective_count.to_f,
            :tpm => tpm.to_f
          }
        end
      end
      expression
    end


  end

end
