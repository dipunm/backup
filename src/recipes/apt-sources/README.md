# Apt sources
This recipe will backup and restore apt sources, preferences and keys.

## Restoring
When restoring, a backup of all modified/replaced files under `/etc/apt/` will be created with name: `{original_name}.backup{hash}` where hash is calculated using `$(date '+%s')`.

### trusted.gpg
It is safe to have duplicate keys registered with apt. Therefore, we will
copy the backup `trusted.gpg` file to `/etc/apt/trusted.gpg.d/backup{hash}.gpg`.

### sources.list
If you restore your packages across different debian OSes or to/from 
different versions, you may find similar repositories that are effectively
duplicates with a mismatching `suite` (see: [the sources.list format](http://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html#the%20deb%20and%20deb-src%20types:%20general%20format))

This recipe will compare the backed up sources.list and provide a summary of sources that it will install including information about similar sources. eg:
```bash
# This source exists for the following suites: focal focal-updates focal-security
# deb http://gb.archive.ubuntu.com/ubuntu/ eaon-updates main
```

In the above case, `eaon` is the codename for an older version of Ubuntu 
than `focal` and the comment shows that this source exists for the 
`focal-updates` suite which means we shouldn't install this source. Since 
this is the most common scenario, we comment these lines out by default.

Consider the following:
```bash
# This source exists for the following suites: wheezy wheezy/updates
# deb http://http.us.debian.org/debian testing main
```

This shows that your backup installed a source for the `testing` suite, and that a similar source for the `wheezy` suite already exists. In this
case, `wheezy` is not a newer suite than `testing`, but rather an 
alternative and so this repository should probably be included. You will need to uncomment the line to install it.

### preferences.d
You can read about the preferences.d folder [here](http://manpages.ubuntu.com/manpages/bionic/man5/apt_preferences.5.html). Any duplicate files in this folder will be backed up as described above.