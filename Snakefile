report: 'docs/index.rst'

configfile: 'config.yml'

rule all:
    input:
        'docs/html/plot.html'
        , 'png/plot2.png'
        , 'docs/html/plot3.html'
        , 'testlog/check_utilR.txt'
        , 'docs/rst/readme.rst'
        , 'docs/index.rst'

rule load_dataset:
    output:
        'feather/data.feather'
    conda:
        'envs/snakemake_minimal_debian.yml'
    benchmark:
        'benchmark/load_dataset.txt'
    script:
        'exec/load.py'

rule plot_rmd_direct:
    input:
        'feather/data.feather'
    output:
        report('docs/html/plot.html', category = 'plot')
    benchmark:
        'benchmark/plot_data.txt'
    script:
        'exec/plot.Rmd'


rule plot_rmd_via_script:
    input:
        'Rmd/plot2.Rmd'
        , 'feather/data.feather'
    output:
        report('docs/html/plot2.html', category = 'plot')
        , report('png/plot2.png', category = 'plot')
    benchmark:
        'benchmark/plot_data2.txt'
    script:
        'exec/plot2.R'
        
rule plot_execute_nb_plot:
    conda:
        'envs/snakemake_minimal_debian.yml'
    input:
        'nb/plot3.ipynb'
        , 'feather/data.feather'
    output:
        temp('docs/html/plot3.ipynb')
    benchmark:
        'benchmark/plot_data3.txt'
    script:
        'exec/plot3.py'
        
rule plot_nb_2_html:
    conda:
        'envs/snakemake_minimal_debian.yml'
    input:
        'docs/html/plot3.ipynb'
    output:
        report('docs/html/plot3.html', category = 'plot')
    benchmark:
        'benchmark/plot_data3.txt'
    shell:
        'jupyter nbconvert --to html {input}'

test_files, = glob_wildcards('utilR/tests/testthat/{test_file}.R')
function_files, = glob_wildcards('utilR/R/{function_file}.R')

rule test_utilR:
    input:
        expand('utilR/R/{function_file}.R', function_file = function_files)
        , expand('utilR/tests/testthat/{test_file}.R', test_file = test_files)
    output:
        'testlog/test_utilR.txt'
    shell:
        "Rscript -e 'sink(\"{output}\")' -e 'devtools::test(\"./utilR\")' -e 'sink()'"
        
rule check_utilR:
    input:
        expand('utilR/R/{function_file}.R', function_file = function_files)
        , expand('utilR/tests/testthat/{test_file}.R', test_file = test_files)
        , 'testlog/test_utilR.txt'
    output:
        'testlog/check_utilR.txt'
    shell:
        "Rscript -e 'sink(\"{output}\")' -e 'devtools::check(\"./utilR\")' -e 'sink()'"


# Report -------------------------------------------------------------------------------------

rule readme:
    input:
        'README.md'
    output:
        report('docs/rst/readme.rst', caption='docs/rst/readme.rst', category = 'README')
    shell:
        "pandoc {input} --from markdown --to rst -s -o {output}"

rule index_md:
    output:
        'docs/index.md'
    script:
        'Rmd/index.Rmd'

rule index_rst:
    input:
        'docs/index.md'
    output:
        'docs/index.rst'
    shell:
        "pandoc {input} --from markdown --to rst -s -o {output}"
