
configfile: 'config.yaml'

rule all:
    input:
        'html/plot.html'
        , 'png/plot2.png'
        , 'html/plot3.html'


rule load_dataset:
    output:
        'feather/data.feather'
    conda:
        'envs/snake_minimal_macos.yml'
    benchmark:
        'benchmark/load_dataset.txt'
    script:
        'exec/load.py'

rule plot_rmd_direct:
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


rule plot_rmd_via_script:
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
        
rule plot_execute_nb_plot:
    conda:
        'envs/snake_minimal_macos.yml'
    input:
        'nb/plot3.ipynb'
        , 'feather/data.feather'
    output:
        temp('html/plot3.ipynb')
    benchmark:
        'benchmark/plot_data3.txt'
    script:
        'exec/plot3.py'
        
rule plot_nb_2_html:
    conda:
        'envs/snake_minimal_macos.yml'
    input:
        'html/plot3.ipynb'
    output:
        'html/plot3.html'
    benchmark:
        'benchmark/plot_data3.txt'
    shell:
        'jupyter nbconvert --to html {input}'
