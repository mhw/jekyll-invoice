# jekyll-invoice

`jekyll-invoice` is a collection of Jekyll plugins and conventions
to produce nice HTML invoices.
The conventions show how to lay out a Jekyll site
in which posts hold invoice details
and the generated site contains printable invoices.
Data files in the `_data` directory hold details
such as customer addresses and tax rates.
The Jekyll plugins provide a simple DSL and data model
to express invoice details (payment rates and invoice lines)
and Liquid filters to format the different types of data used in an invoice
(addresses, money, invoice numbers and so on).

`jekyll-invoice` is currently designed to support billing for freelancers,
but the internal DSL used to capture invoice details
is quite flexible and could be expanded for other uses.
It provides templates suitable for UK companies,
but supporting other countries should be relatively simple.

## Installation

`jekyll-invoice` hasn't yet been released through rubygems.org,
so the simplest way to get started at the moment is to bootstrap
a new jekyll site using bundler. In a new directory create an
initial Gemfile containing the following:

    source 'https://rubygems.org'

    gem 'jekyll-invoice', github: 'mhw/jekyll-invoice'

And then execute:

    $ bundle install --path vendor

This will install the necessary gems in the `vendor` subdirectory
instead of adding them to your standard set of Ruby gems,
which is probably what you want.

You then need to populate the directory with the files that
`jekyll-invoice` expects. The easiest way to do this is by copying
the files from jekyll-invoice's `templates` directory:

    $ d=`bundle show jekyll-invoice`
    $ tar cf - -C $d/templates/base . | tar xf -
    $ tar cf - -C $d/templates/uk . | tar xf -

This will create a site suitable for a UK-based company.
If you localise the templates for your own territory,
please do contribute your changes.
Eventually there will also be a command to automate this set-up
process to some extent.

## Usage

The templates include a `Rakefile` that supports a basic workflow:

    $ rake draft[big_biz]

will create a new invoice in `_drafts`, automatically giving it the
next invoice number in sequence. You can pass a single argument to
the `draft` task, which is the name of a customer in the
`_data/customers.yml` file - `big_biz` in this case.

    $ rake issue

will present a list of draft invoices. Select one by number and it
will be moved into `_posts` and given the current date.

    $ rake invoice[big_biz]

Combines the two steps into one, creating a new invoice in `_posts`.

## Contributing

1. Fork it ( http://github.com/mhw/jekyll-invoice/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
