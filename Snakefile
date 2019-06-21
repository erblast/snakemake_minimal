
configfile: 'config.yaml'

rule all:
    input:
        'html/plot.html'
        , 'png/plot2.png'
        , 'html/plot3.html'
        , 'testlog/check_utilR.txt'

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

test_files, = glob_wildcards('utilR/tests/testthat/{test_file}.R')
function_files, = glob_wildcards('utilR/R/{function_file}.R')

rule test_utilR:
    conda:
        'envs/snake_minimal_macos.yml'
    input:
        expand('utilR/R/{function_file}.R', function_file = function_files)
        , expand('utilR/tests/testthat/{test_file}.R', test_file = test_files)
    output:
        'testlog/test_utilR.txt'
    shell:
        "Rscript -e 'sink(\"{output}\")' -e 'devtools::test(\"./utilR\")' -e 'sink()'"
        
rule check_utilR:
    conda:
        'envs/snake_minimal_macos.yml'
    input:
        expand('utilR/R/{function_file}.R', function_file = function_files)
        , expand('utilR/tests/testthat/{test_file}.R', test_file = test_files)
        , 'testlog/test_utilR.txt'
    output:
        'testlog/check_utilR.txt'
    shell:
        "Rscript -e 'sink(\"{output}\")' -e 'devtools::check(\"./utilR\")' -e 'sink()'"
