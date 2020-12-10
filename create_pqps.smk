run, = glob_wildcards("tsv/{run}.tsv")


rule all:
    input:
        expand("pqp/{run}_DECOY.PQP", run=run)



rule OpenSwathAssayGenerator:
    input:
        tsv = "tsv/{run}.tsv",
    output:
       PQP = "assays/{run}.PQP"
    threads: 1
    shell:
        "OpenSwathAssayGenerator -in {input.tsv} -max_transitions 8 -min_transitions 6 -precursor_lower_mz_limit 350 -precursor_upper_mz_limit 1650 -enable_detection_specific_losses -enable_detection_unspecific_losses -swath_windows_file bruduer_HFX_44win.txt -out {output.PQP}"

rule OpenSwathDecoyGenerator:
    input:
       PQP = "assays/{run}.PQP"
    output:
        PQP = "pqp/{run}_DECOY.PQP"
    threads: 1
    shell:
        "OpenSwathDecoyGenerator -in {input.PQP} -out {output.PQP} -enable_detection_specific_losses -enable_detection_unspecific_losses"
