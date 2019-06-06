# snakemake minimal workflow
In `Snakefile` a set of rules are supplied on the basis of which output files are
supposed to be produced by the workflow.

It is customary to start with `rule all` a blank rule that uses all final output files as input files.
`snakemake` will go through the rest of the rules and create an execution sequence for all rules based
on the first rule. It will also determine which steps can be executed in parallel.

## Execute
```shell
snakemake
```

## Dryrun
```shell
snakemake -n

```

## Execute after code changes
```shell
snakemake -R `snakemake --list-code-changes`
```

## Force re-execution
```shell
snakemake -F
```

## Parallel Processing

```shell
snakemake --cores 3
```

## Execute and build conda environment

The conda environment will be reconstructed from `yml` file and stored in `./.snakemake/conda`.
A single conda environment can be defined for each rule.

```shell
conda env export -f ./envs/snake_minimal_macos.yml
```

```shell
snakemake --use-conda
```


## Visualize workflow
```shell
snakemake --dag | dot -Tpng > ./wflow/wflow.png
```

![](./wflow/wflow.png)

## YAML configuration file
`config.yaml`

# Shell vs Scripts
Scripts in `R` and `python` have access to a `snakemake` object carrying all rule
parameters as attributes. However when shell commands can be constructed snakemake's
parallel processing and logging capabilities can be leveraged.

# R Scripts and Markdown
R scripts can be added as `.R` or as `.Rmd`. When they are added as `.Rmd` they
can only produce one single html-output file. A workaround is to use an intermediate
R script as shown in rule `plot_data2`.

**see rules `plot_rmd_direct` and `plot_rmd_via_script` in [Snakefile](https://github.com/erblast/snakemake_minimal/blob/master/Snakefile)**

# Python Scripts and Jupyter Notebooks
Python scripts can be added as `.py` files. We can use `papermill` to execute
parametrized jupyter notebooks which we can then render as html. html is preferred
to notebooks because there is no doubt about the execution state.

**see rules `plot_execute_nb` and `plot_nb_2_html` [Snakefile](https://github.com/erblast/snakemake_minimal/blob/master/Snakefile)**


## Benchmarking
Execution times of each rule are stored in `./benchmark`. Can be defined in `Snakefile`

## Logging
unfortunately logging is not supported for scripts thus needs to be setup
for each script individually using script-language-specific tools.
https://bitbucket.org/snakemake/snakemake/issues/917/enable-stdout-and-stderr-redirection
