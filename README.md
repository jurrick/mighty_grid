# MightyGrid [![Gem Version](http://img.shields.io/gem/v/mighty_grid.svg)](http://badge.fury.io/rb/mighty_grid) [![Build Status](https://travis-ci.org/jurrick/mighty_grid.svg?branch=master)](https://travis-ci.org/jurrick/mighty_grid) [![Code Climate](https://codeclimate.com/github/jurrick/mighty_grid.png)](https://codeclimate.com/github/jurrick/mighty_grid) [![Inline docs](http://inch-ci.org/github/jurrick/mighty_grid.png)](http://inch-ci.org/github/jurrick/mighty_grid)

MightyGrid is a flexible grid solution for Ruby On Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'mighty_grid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mighty_grid

## Quick Start

### Controller

You can define class or relation in <tt>init_grid</tt> method.

```
def index
  @products_grid = init_grid(Product)
end
```

### Show View

```
<%= grid @products_grid do |g| %>
  <% - g.column :id %>
  <% - g.column :name %>
  <% - g.column :description %>
<% end %>
```

## Usage

### General configuration options

You can configure the following default values by overriding these values using <tt>MightyGrid.configure</tt> method.

```
per_page                # 15 by default
order_direction         # 'asc' by default
order_type              # 'single' by default
order_asc               # '&uarr;' by default
order_desc              # '&darr;' by default
order_asc_link_class    # '' by default
order_desc_link_class   # '' by default
order_active_link_class # 'mg-order-active' by default
order_wrapper_class     # '' by default
grid_name               # 'grid' by default
table_class             # '' by default
header_tr_class         # '' by default
pagination_theme        # 'mighty_grid' by default
```

There's a handy generator that generates the default configuration file into config/initializers directory.
Run the following generator command, then edit the generated file.

    $ rails g mighty_grid:install

## Running tests

To run the tests you need specify database and Rails version.

* List of available Rails versions: 4.0, 4.1, 4.2.
* List of DB: sqlite, postgresql, mysql.

Example run:

    $ DB=postgresql appraisal rails_41 rake spec cucumber

## Contributing

1. Fork it ( http://github.com/jurrick/mighty_grid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
