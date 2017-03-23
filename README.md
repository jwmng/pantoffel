# Pantoffel

Static websites in a single `make`.
Boredom project, train Wifi didn't work.

## Usage instructions

Write articles in [markdown](https://daringfireball.net/projects/markdown/), styles in [sass](http://sass-lang.com/) (or plain CSS) and use `make website` to compile everything into HTML and CSS.

- Put articles in `content/articles`, written in markdown and ending in `.md`
- Put sass files in `content/sass`
- Put CSS, JS and other assets like images in `content/static`
- Home page content goes in `content/home.md`
- Website title goes in `content/title.txt`

Every step/operation is contained in the makefile which supports the following targets:

- `make website`: Compile pages, less and copy static content to `site`
- `make clean`: Cleanup
- `make deploy`: Deploy site files

## Templates

To change a template, just edit the file in the `templates/` folder.
Template variables start with with `@`; The chart below shows which variables are allowed for each template.

[!flowchart](docs/flowchart.png)

_Note:_ Make sure to put each variable on its own line.

## Deploy 

Invoking `make deploy` will call `./bin/deploy` with the `site` path as first argument. 
Example `./bin/deploy` using `scp`:

~~~
#!/bin/sh
scp -r $1 web-user@mywebserver:/var/www/website
~~~

## Changing executables

The default sass compiler (`sassc`), markdown compiler (`markdown_py`) and the content substitution scripts are called through `bin`.
If you want to change them, either relink the symlinks or edit the variables in the Makefile.
