# MightyGrid

MightyGrid is a flexible grid solution for Rails.

[![Gem Version](https://badge.fury.io/rb/mighty_grid.svg)](http://badge.fury.io/rb/mighty_grid)
[![Build Status](https://travis-ci.org/jurrick/mighty_grid.svg?branch=master)](https://travis-ci.org/jurrick/mighty_grid)
[![Coverage Status](https://coveralls.io/repos/jurrick/mighty_grid/badge.png)](https://coveralls.io/r/jurrick/mighty_grid)
[![Inline docs](http://inch-pages.github.io/github/jurrick/mighty_grid.png)](http://inch-pages.github.io/github/jurrick/mighty_grid)

## Installation

Add this line to your application's Gemfile:

    gem 'mighty_grid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mighty_grid

## Usage

### General configuration options

You can configure the following default values by overriding these values using <tt>MightyGrid.configure</tt> method.
```
per_page          # 15 by default
order_direction   # 'asc' by default
grid_name         # 'grid' by default
table_class       # '' by default
header_tr_class   # '' by default
pagination_theme  # 'mighty_grid' by default
```

There's a handy generator that generates the default configuration file into config/initializers directory.
Run the following generator command, then edit the generated file.

    $ rails g mighty_grid:config

## Contributing

1. Fork it ( http://github.com/jurrick/mighty_grid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
