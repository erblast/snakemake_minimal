FROM erblast/r_conda_snakemake_pkgs

COPY * /snakemake_minimal

RUN cd snakemake_minimal && snakemake --use-conda