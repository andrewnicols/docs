---
title: NodeJS
---
(tools-nodejs)=

A number of development tools require the installation and use of [NodeJS](https://nodejs.org/en/), which is a JavaScript runtime
environment available freely for most operating systems.

```{include} ../_templates/node_version.md
```
We highly recommend using [NVM](tool-nodejs-nvm) to install NodeJS rather than installing it directly.

(tool-nodejs-nvm)=

## NVM

[NVM](https://github.com/nvm-sh/nvm) is the Node Version Manager. Its purpose is to simplify the installation, and use of multiple versions of NodeJS.

Moodle includes a `.nvmrc` which `nvm` can use to select the correct version of NodeJS.

To use the correct version of NodeJS for the current version of Moodle, you can use the `nvm install` and `nvm use` commands:
```bash
$ nvm install
Found '/Users/nicols/Sites/public_html/sm/.nvmrc' with version <lts/gallium>
v16.14.0 is already installed.
Now using node v16.14.0 (npm v8.3.1)
```
## Grunt

As part of it's build stack, Moodle uses the [Grunt](https://gruntjs.com) task runner.

Grunt is composed of a set of tasks, defined within the Moodle code repository in the `Gruntfile.js` file, and a grunt
CLI tool which must be installed separately.

To install the grunt CLI tool you can install it globally using npm:
```bash
$ npm install -g grunt-cli
$ grunt stylelint
```

Alternatively you can use the `npx` command to install it on demand:
```bash
$ npx grunt stylelint
```
