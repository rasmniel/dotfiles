# TidalCycles workspace configuration

This collection of Haskell files constitute a baseline for setting up TidalCycles with SuperCollider.


## Cabal

It is not strictly necessary to build with cabal for the TidalCycles setup to work, but it can help find errors in the project.
The `tidal-config.cabal` file contains enough setup to run and build the project with `tidal` dependencies using:

```
cabal update
cabal build
```


## Caveats

In order to run GHCi from an arbitrary directory, it must contain a `.ghci` file.
This file and the containing directory _must_ not be writable by anyone other then the process owner.
This is an intended security feature of GHCi, because the `.ghci` file could contain any arbitrary shell level commands.
This configuration is necessary, but does not interfere with GHCi apart from requiring the setup.
If the permissions of the `.ghci` file or containing directory is incorrect, GHCi will warn about this when executed.
To solve the issue, run the commands suggested by GHCi `chmod go-w .ghci` and `chmod go-w .` in the given directory.
Note that GHCi doesn't care about excessive read permissions, as long as it has the correct read permission to read the `.ghci` file.

