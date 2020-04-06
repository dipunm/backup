- Plan out binary api
- Build all binary paths
- Create installer
- Create release
- Test


----

Change restore API:
mbkp restore ARCHIVE (-a|--all)
mbkp restore ARCHIVE (-f|--files-only)
mbkp restore ARCHIVE (-r|--recipes) RECIPE...

Move configuration to configs folder and plan user flow for recipe installation + configuration

Backups should transfer configs to $DIR_STORE if needed for restoring

Restore should load configs from $DIR_STORE folder

Restore using -r flag should extract $DIR_STORE from archive before running
