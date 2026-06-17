# Creating a Debian Package


## Setup

For a Debian installation (.deb) file, the project directory should contain:

1) A DEBIAN directory
2) The path structure that defines the installation location(s),

e.g. for a shell script:

```
trackf/
├── DEBIAN/
└── usr/
    └── local/
        └── bin/
```

Each destination directory should contain the files to be installed at that location.

## Build

1) Remove any existing .deb packages from the package directory (unless ignored in .gitignore)
2) Change to the directory above the package directory
3) Run dpkg-deb --build with options as follows:
 * If the project has been cloned, add the --root-owner-group to ensure correct ownership assignment of the project files
 * Provide the project source directory followed by the required package name, e.g.:

```dpkg-deb --root-owner-group --build trackf trackf_1.0-1_all.deb```

4) To be able to provide a link to the latest release in GitHub, copy the file and include it in the release's upload:

```cp trackf_1.0-1_all.deb trackf_latest_all.deb```

## Install

```sudo dpkg -i ./trackf_1.0-1.deb```

## Rebuild

If code changes have been made, update the version number in the DEBIAN/control file, and use that same number in the build command.


