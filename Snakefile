
configfile: 'config.yaml'

rule all:
    input:
        # 'feather/data.feather'
        'html/plot.html'
        , 'png/plot2.png'

rule load_dataset:
    output:
        'feather/data.feather'
    conda:
        'envs/snake_minimal_macos.yml'
    benchmark:
        'benchmark/load_dataset.txt'
    script:
        'exec/load.py'

rule plot_data:
    conda:
        'envs/snake_minimal_macos.yml'
    input:
        'feather/data.feather'
    output:
        'html/plot.html'
    benchmark:
        'benchmark/plot_data.txt'
    script:
        'exec/plot.Rmd'


rule plot_data2:
    conda:
        'envs/snake_minimal_macos.yml'
    input:
        'Rmd/plot2.Rmd'
        , 'feather/data.feather'
    output:
        'html/plot2.html'
        , 'png/plot2.png'
    benchmark:
        'benchmark/plot_data2.txt'
    script:
        'exec/plot2.R'
