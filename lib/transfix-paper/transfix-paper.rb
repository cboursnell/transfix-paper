module TransfixPaper

  class Paper

    def initialize



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
    #  -

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

  end

end
