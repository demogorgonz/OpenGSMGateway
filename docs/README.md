# MM-DOCS Template

[![Build status](https://github.com/majkinetor/mm-docs-template/actions/workflows/mm-docs.yml/badge.svg)](https://github.com/majkinetor/mm-docs-template/actions/workflows/mm-docs.yml)
[![](http://transparent-favicon.info/favicon.ico)](#)
[![](http://transparent-favicon.info/favicon.ico)](#)
[VIEW DEMO](https://majkinetor.github.io/mm-docs-template)

This project is used to produce all forms of documentation for the service using Markdown and other repository friendly markup languages.

The documentation is created using the [mm-docs](https://github.com/majkinetor/mm-docs) documentation bundle.

View how compiled static site looks like on [demo site](https://majkinetor.github.io/mm-docs-template) or grab generated [artifact](https://ci.appveyor.com/project/majkinetor/mm-docs-template/build/artifacts). Check out [pdf export](https://majkinetor.github.io/mm-docs-template/docs.pdf) of [single demo page](https://majkinetor.github.io/mm-docs-template/demo).

See entire docs as a [single page](https://majkinetor.github.io/mm-docs-template/print_page/) and/or [download](https://majkinetor.github.io/mm-docs-template/download/) it.

## Features

- Documentation in Markdown, HTML, PlantUML, MatJax
- Beautiful responsive design using the [material](https://squidfunk.github.io/mkdocs-material) theme
- Navigational bar, TOC, color themes, go-to-top, search and various rich presentation functionalities
- Custom includables that can be imported in any page: footer, header, abbreviations etc.
- Variables, Python macros and jinja templates
- Multilanguage support
- Keep documentation for multiple user groups in the same project and build only specific one
- Fast PDF export and single page documentation site
- Bad link checker for internal and external links
- Metainformation for every page - last git modification date, source file, authors, etc.
- GitLab/GitHub repository connection for editing within a browser
- Automated AppVeyor and Github actions build and deploy to GitHub pages using Ubuntu image
- Live reload during editing
- Cross platform for hosting and development with convenient optional PowerShell task system

## Prerequisites

- Docker installation.
  - For Windows Desktop use: `cinst docker-desktop`
- PowerShell (optional)
  - [Invoke-Build](https://www.powershellgallery.com/packages/InvokeBuild) module

## Usage

Within PowerShell use `Invoke-Build` (ib):

|     Task     |                Description                 |
| ------------ | ------------------------------------------ |
| `Build`      | Build static site                          |
| `Run`        | Serve static site locally with live reload |
| `Stop`       | Stop  running container                    |
| `CheckLinks` | Check internal and external links          |
| `ExportPdf`  | Export PDF of entire site                  |
| `ExportHTML` | Export standalone HTML of the entire site  |
| `ExportSite` | Export entire site archive for offline use |
| `Clean`      | Remove generated data                      |

Otherwise, run appropriate docker commands:

```sh
export image=majkinetor/mm-docs
export aPort=8888

#build
docker run --rm -v $PWD:/docs8 $image mkdocs build

#serve
docker run --rm -v $PWD:/docs --name docs-$aPort --detach -p $aPort:$aPort $image mkdocs serve --dev-addr 0.0.0.0:$aPort
```

After building it, static site is available at `source\site` directory and it can be served with any kind of web server.

## Adding documents

- Add new markdown somewhere in the `source/docs` directory.
- To be visible in navigation, add to `source/mkdocs.yml` `nav` section, otherwise, the page is available via direct link
- Add footer, header, abbreviations etc. in `source/inc` folder
- Add python function and modules in `source/main.py`
- Override specific mkdocs material theme partials in `source/overrides`
- Configure PDF and single page stuff in `source/pdf`
- Configure extra CSS in `docs/_extra/css`

## Notes

- To build only specific section (using `ib -aSection <sectionName>`), make sure you have `regex: []` under `exclude` plugin. Because mkdocs builds all pages no matter if they are present in the `nav` section or not, this plugin option is used to NOT build other sections.
