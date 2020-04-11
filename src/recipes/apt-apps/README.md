# Apt apps
This recipe will backup and restore any named package. Note that this recipe does not keep track of apt-sources. Therefore, if you reference a package that is defined in a ppa or private repository, you will want to include the `apt-sources` recipe; order is important, so ensure that this recipe runs AFTER `apt-sources`.

Packages are defined in the recipe config file in a variable as follows:
```bash
packages=( 
    wget curl 
    python3 
)
```

Each package should be separated by white space (this can be a space, tab, and/or new line). There should be at least one package defined. If no packages are defined, the recipe will report an error during backup and restore.